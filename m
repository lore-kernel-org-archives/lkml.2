Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab0IUOJC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:09:02 -0400
Received: from web50107.mail.re2.yahoo.com ([206.190.38.35]:27619 "HELO
	web50107.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754724Ab0IUOJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:09:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=yLHEMjsl1XX2vd5YZyaLmojhnHmcTPvinWyyc6zweZlixflLJfsO2/a0exdRaKOWUuC7lLW4r4JBWdqiFvyJXmnyYAB8dcoh5srBcGMb3OdfvoEmNWSFrW5UztEEKWSFoZIwkWTq4SFBJE7hdym6/oYxYuHkYqYjFkq12SwYG6k=;
Message-ID: <245167.20496.qm@web50107.mail.re2.yahoo.com>
X-YMail-OSG: H5PMGGkVM1mqd7R_x21KFk4Ui1YLtRXP2xGZnW0I2bro0l9
 iOOIWjQkzg1sXPxRTmrMZSv3Y0lgEQeHljFPqFtW2Mf5OZg65g31b8nFc6YF
 hmz8cdbJjJivYQvwA1_4Xj9YgOHcxkajEV0OQf_QvFXkGoTTypkUkcA8gFXt
 EMAp2GcClNoFHcFbQmxZlVKcttpOLTBPz5Td5c21hlGCVvhS5nIZCpHp9C6b
 TiRfIU0GNG28diulVpmYruWrwoqO4RN4Z4D_b400QjUhBwo.QwyWgeF23cLA
 Kvjl9m4.UqLnXVVbEhILxYwLMZUifUNl2y6fp7p1opHB9SBGuBBzXN48-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.105.279950
Date: Tue, 21 Sep 2010 07:08:58 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [RFC 3/6] x86, NMI, Rename memory parity error to PCI SERR error
To: Huang Ying <ying.huang@intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Cc: RobertRichter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        edac-devel <linux-edac@vger.kernel.org>
In-Reply-To: <20100921063740.GA14394@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Tue, 9/21/10, Borislav Petkov <borislav.petkov@amd.com> wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> Subject: Re: [RFC 3/6] x86, NMI, Rename memory parity error to PCI SERR error
> To: "Huang Ying" <ying.huang@intel.com>
> Cc: "Richter, Robert" <robert.richter@amd.com>, "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Andi Kleen" <andi@firstfloor.org>, "Doug Thompson" <norsk5@yahoo.com>, "edac-devel" <linux-edac@vger.kernel.org>
> Date: Tuesday, September 21, 2010, 12:37 AM
> From: Huang Ying <ying.huang@intel.com>
> Date: Mon, Sep 20, 2010 at 08:22:28PM -0400
> 
> (Forgot to add edac-devel to Cc)

thanks


> 
> > > What is more, there are a bunch of edac drivers
> using the PCI SERR nmi
> > > as a means to check for PCI errors so we
> shouldn't be removing it now,
> > > should we?
> > 
> > After checking the source, I found in mem_parity_error
> (will renamed to
> > pci_serr_error), edac_atomic_assert_error() is called,
> which increase
> > edac_err_assert, edac_err_assert is used in
> > edac_mc_assert_error_check_and_clear(), which is used
> in
> > edac_mc_workq_function for memory error only, not for
> PCI errors.
> 
> Yes, I suppose the edac part in the mem_parity_error() was
> originally
> meant for memory parity errors. Now, I understand your
> incentive of
> changing that to handle PCI SERR errors but by axing the
> edac part,
> you're practically disabling the mci->edac_check() call
> for edac
> drivers using NMIs for error reporting (I don't know how
> many do that,
> btw...) and almost every edac driver defines that function
> pointer to a
> driver-specific error checking function.
> 
> So if there are no more IBM PC-AT machines running Linux
> out, I
> think we can rip out the whole code around edac_err_assert
> and thus
> remove the edac_mc_assert_error_check_and_clear() part from
> the
> edac_mc_workq_function() which would make all edac drivers
> solely poll
> for mem errors.
> 
> What do the others think, Doug?

History lesson:

The addition of PCI bus ERROR scanning was added to EDAC when we (at Linux Networx, 2005 timeframe) discovered a bad PCI riser card. Due to bad manufacturing, it would cause PCI bus errors during transfers. We determined that by scanning the PCI bus, we could isolate bad cards and verify proper PCI bus operation on those cards and other PCI devices.

Once that was in place, we found other systems that also had PCI bus errors, though less frequently than our original system. A handful of errors were discovered and we found that not many systems were handling any of them, nor even reporting them. Hence the PCI bus scanner of EDAC.  I profiled it, and it took on average 2500 TSC cycles to perform a complete bus scan which occurred every second. So it was an expensive operation. That is why I added controls to turn off PCI bus scanning if desired.

Memory parity errors via NMI was NOT the prime reason it was added to EDAC. Looking at SERR (or any PCI bus error) was the prime reason it was added. There was a patch to better handle NMI event handling better, but didn't get pushed upstream.'



I have not kept up with the kernel PCI SERR error handling code development else (if any) and don't fully know its features nor current operation.

If it is determined that EDAC no longer needs to scan the PCI bus because some other system is now managing that error checking operation, great!  

It was a wart in a way, hanging in the memory driver. I really wanted to revisit that and either set it up as a separate driver or embedded in the EDAC core or something.



doug thompson



> 
> -- 
> Regards/Gruss,
> Boris.
> 
> Advanced Micro Devices GmbH
> Einsteinring 24, 85609 Dornach
> General Managers: Alberto Bozzo, Andrew Bowd
> Registration: Dornach, Gemeinde Aschheim, Landkreis
> Muenchen
> Registergericht Muenchen, HRB Nr. 43632
> 
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab2CLS6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:58:52 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51755 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab2CLS6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:58:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Fernando Luis =?utf-8?Q?V=C3=A1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
        "H. Peter Anvin" <hpa@zytor.com>, Don Zickus <dzickus@redhat.com>,
        linux-tip-commits@vger.kernel.org, torvalds@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu,
        Yinghai Lu <yinghai@kernel.org>, akpm@linux-foundation.org
References: <m1ipip6xe8.fsf@fess.ebiederm.org>
	<4F573E1C.2060909@oss.ntt.co.jp> <4F573E74.5040504@oss.ntt.co.jp>
	<m1eht31z8e.fsf@fess.ebiederm.org> <4F58495B.5080308@oss.ntt.co.jp>
	<m1r4x3yrsv.fsf@fess.ebiederm.org> <4F5A6D87.4050809@zytor.com>
	<4F5D8D0E.8060702@oss.ntt.co.jp> <4F5D8E63.60606@zytor.com>
	<4F5D943C.5020403@oss.ntt.co.jp> <20120312133619.GB17288@redhat.com>
Date: Mon, 12 Mar 2012 12:02:06 -0700
In-Reply-To: <20120312133619.GB17288@redhat.com> (Vivek Goyal's message of
	"Mon, 12 Mar 2012 09:36:19 -0400")
Message-ID: <m1ipi9prrl.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18JSB3MG1iSqZ4Dm9s8O91E9QCdWWS9UlI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.2 SARE_LWSHORTT BODY: SARE_LWSHORTT
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 1/2] boot: ignore early NMIs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Mon, Mar 12, 2012 at 03:14:20PM +0900, Fernando Luis Vázquez Cao wrote:
>
> [..]
>> The thing is that we want to avoid playing with hardware in the kdump
>> reboot patch when we can avoid it, the premise being that it cannot
>> be accessed without risking a lockup or worse (as the deadlock accessing
>> the I/O APIC showed).
>
> I think there needs to be a limit to being paranoid. On one hand people
> want to run panic notifiers, all the kmsg_dump() hooks in panic path, and
> on the other hand we are afraid of even disabling LAPIC.

And the kmsg_dump code and the panic notifiers aren't being run.  Having
seen some of their failure modes being patched up recently (Adding and
removing sysfs files!!!!) I'm very comfortable with the level of
paranoia.

It has been proven time and time again that the more you do in the
failing kernel that the greater your likely-hood of not getting your
failure information out.

> I personally think that disabling LAPIC is reasonably practical solution
> to the problem until and unless somebody shows that it deadlocks
> easily.

Disabling NMI generation in the LAPIC is fine, and for the short term
I don't even have a problem with disabling the entire LAPIC as all of
our platforms seem to have code for completely reprogramming it.

At the same time there have been cases like the i8259 routed through
the ExtInt pin of the lapci that we haven't been given programming
information about and that if we want to work we should avoid touching.

Furthermore we have two reported cases of people experiencing real NMIs
on the kdump path.  So we have to assume the presence of the CMOS nmi
disable as well if we are going to unequivocally disable NMIs.

Given the variety of x86 hardware today and the growing variety of x86
hardware tomorrow we are going to be fixing this until we can actually
handle the NMIs.  Hardware designers are unfortunately creative enough
that we aren't going to think of everything.  Given that it is has taken
us almost a decade to realize that there actually is a real world
problem  I'm not too keen on a solution that is just good enough to
fix a small problem.

I would love it if x86 had an architectural NMI off switch but with
Intel pushing EFI and the removal of the cmos clock x86 no longer
has an always available NMI off switch.

Furthermore handling of NMI is not hard it is just a little tricky,
to test.

Eric

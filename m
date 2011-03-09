Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab1CITdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 14:33:06 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:37204 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab1CITdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 14:33:04 -0500
Date: Wed, 9 Mar 2011 20:30:03 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Zachary Amsden <zamsden@redhat.com>
Cc: KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Subject: Re: [PATCH] add missing guest clock update removed by
	e48672fa25e879f7ae21785c7efd187738139593
Message-ID: <20110309193003.GB1762@pcnci.linuxbox.cz>
References: <20110307101827.GA1762@pcnci.linuxbox.cz> <4D768A62.3050903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D768A62.3050903@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4796234 records (last update: 20110309)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you try moving the kvm_make_request() inside the if conditional and  
> see if it that also fixes it?

yes, changing to:
if (unlikely(vcpu->cpu != cpu) || check_tsc_unstable()) {
	kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
	/* Make sure TSC doesn't go backwards */
	s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :

is also OK.

what about changing:
if (check_tsc_unstable()) {
	kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);                                                                                                               
	vcpu->arch.tsc_catchup = 1;
	kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
}                                                                                                                                                                       

to:

if (check_tsc_unstable()) {
	kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);                                                                                                               
	vcpu->arch.tsc_catchup = 1;
}                                                                                                                                                                       
kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);

this fixes thinks for me as well..
n.
?


> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

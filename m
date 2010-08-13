Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab0HMWUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 18:20:11 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44128 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab0HMWUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 18:20:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, vgoyal@redhat.com,
        nhorman@tuxdriver.com
References: <F0CB3B1C601247indou.takao@jp.fujitsu.com>
Date: Fri, 13 Aug 2010 15:19:56 -0700
In-Reply-To: <F0CB3B1C601247indou.takao@jp.fujitsu.com> (Takao Indoh's message
	of "Fri, 13 Aug 2010 15:18:56 -0400")
Message-ID: <m1iq3ep33n.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: marc.info]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Takao Indoh <indou.takao@jp.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH][EFI] Run EFI in physical mode
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takao Indoh <indou.takao@jp.fujitsu.com> writes:

> Hi all,
>
> The attached patch enables EFI to run in physical mode.
>
> Basically EFI is in physical mode at first and it's switched to virtual
> mode after calling SetVirtualAddressMap. By applying this patch, you can
> run EFI always in physical mode. And you can also specify "virtefi" as
> kernel boot parameter to run EFI in virtual mode as before. Note that
> this patch supports only x86_64.
>
> This is needed to run kexec/kdump in EFI-booted system. The following is
> an original discussion. In this thread, I explained that kdump does not
> work because EFI system table is modified by SetVirtualAddressMap. And
> the idea to run EFI in physical mode was proposed. This patch implements
> it.
>
> http://marc.info/?l=linux-kernel&m=128018221820234&w=2
>> When the 1st kernel boots, EFI system table(efi_system_table_t) is
>> modified by SetVirtualAddressMap, which is one of EFI runtime service.
>> This runtime changes physical address in EFI system table to virtual
>> address.
>> 
>> When the 2nd kernel boots, it also receives the same EFI system table,
>> and the address included in it is already virtual address(1st kernel
>> rewrote it).  But 2nd kernel does not know that, 2nd kernel thinks it is
>> a physical address. This causes problems.
>
> Basic idea of this patch is to create EFI own pagetable. This pagetable
> maps physical address of EFI runtime to the virtual address which is the
> same value so that we can call it directly. For example, physical 
> address 0x800000 is mapped to virtual address 0x800000. Before calling
> EFI runtime, cr3 register is switched to this pagetable, and restored
> when we come back from EFI.
>
> Any comments would be appreciated.
>
> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

There is what appears to be unneeded redundancy (we need two
implementations of physciall calls into efi?), but that is confined to
the weird efi state.

It is a shame you haven't done the little bit extra to get
efi_pagetable_init working on x86_32.

Overall this seems sane and confined to the x86 efi, and it looks
like further improvements could easily be layered on top of this one.

Eric

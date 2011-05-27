Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1E0SJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:09:51 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38309 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab1E0SJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:09:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: prasad@linux.vnet.ibm.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck\, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        anderson@redhat.com
References: <20110526170722.GB23266@in.ibm.com>
	<20110526171521.GD17988@in.ibm.com>
Date: Fri, 27 May 2011 11:09:44 -0700
In-Reply-To: <20110526171521.GD17988@in.ibm.com> (K. Prasad's message of "Thu,
	26 May 2011 22:45:21 +0530")
Message-ID: <m1vcww817b.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/VK4SbKWuSm9pve0k4MZGVQH4hcXkEhvs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_Sft_Co_L33T XM_Sft_Co_L33T
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;prasad@linux.vnet.ibm.com
X-Spam-Relay-Country: 
Subject: Re: [RFC Patch 4/6] PANIC_MCE: Introduce a new panic flag for fatal MCE, capture related information
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"K.Prasad" <prasad@linux.vnet.ibm.com> writes:

> PANIC_MCE: Introduce a new panic flag for fatal MCE, capture related information
>
> Fatal machine check exceptions (caused due to hardware memory errors) will now
> result in a 'slim' coredump that captures vital information about the MCE. This
> patch introduces a new panic flag, and new parameters to *panic functions
> that can capture more information pertaining to the cause of crash.
>
> Enable a new elf-notes section to store additional information about the crash.
> For MCE, enable a new notes section that captures relevant register status
> (struct mce) to be later read during coredump analysis.
>
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>


> -void crash_save_vmcoreinfo(void)
> +void crash_save_vmcoreinfo(void *arch_info, size_t arch_info_size,
> +						enum panic_flags flags)
>  {
>  	u32 *buf;
>  
> @@ -1392,9 +1394,12 @@ void crash_save_vmcoreinfo(void)
>  
>  	buf = (u32 *)vmcoreinfo_note;
>  
> -	buf = append_elf_note(buf, VMCOREINFO_NOTE_NAME, 0, vmcoreinfo_data,
> -			      vmcoreinfo_size);
> -
> +	if (flags & PANIC_MCE)
> +		buf = append_elf_note(buf, "PANIC_MCE", NT_MCE, arch_info,
> +					arch_info_size);

Ok.  This is uglier than I thought.  You have this terribly generic
interface than when you go to use it you assume it is an mce.  Ugh
no.

Furthermore you short circuit out other pieces of this code.

This patch is a total hack that is massively over engineered.

Saving NT_MCE is fine, in and of itself.  The rest of the information
is totally nonsense.

Eric


> +	else
> +		buf = append_elf_note(buf, VMCOREINFO_NOTE_NAME, 0,
> +				vmcoreinfo_data, vmcoreinfo_size);
>  	final_note(buf);
>  }
>  

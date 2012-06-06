Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab2FFTQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 15:16:29 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33122 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab2FFTQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 15:16:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
References: <20120605112408.GA11466@dhcp-26-207.brq.redhat.com>
Date: Wed, 06 Jun 2012 12:16:08 -0700
In-Reply-To: <20120605112408.GA11466@dhcp-26-207.brq.redhat.com> (Alexander
	Gordeev's message of "Tue, 5 Jun 2012 13:24:13 +0200")
Message-ID: <87k3zk1cav.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/pNtPw9nz6R3Nl3RJN6yZQ16yYeyXizTU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0036]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexander Gordeev <agordeev@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 5/8] x86: apic: Try to spread IRQ vectors to different priority levels
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Gordeev <agordeev@redhat.com> writes:

> When assigning a new vector it is primarially done by adding 8 to the
> previously given out vector number. Hence, two consequently allocated
> vector numbers would likely fall into the same priority level. Try to
> spread vector numbers to different priority levels better by changing
> the step from 8 to 16.

A weird goal.  Given that linux ignores all priority levels internally
we would be better incrementing by 1.  The practical problem is that
some older hardware would fail if you had more than two devices per
priority level.

Eric


> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 1afedef..f043d6a 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1163,7 +1163,7 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
>  	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
>  	 */
>  	static int current_vector = FIRST_EXTERNAL_VECTOR + VECTOR_OFFSET_START;
> -	static int current_offset = VECTOR_OFFSET_START % 8;
> +	static int current_offset = VECTOR_OFFSET_START % 16;
>  	unsigned int old_vector;
>  	int cpu, err;
>  	cpumask_var_t tmp_mask;
> @@ -1195,10 +1195,9 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
>  		vector = current_vector;
>  		offset = current_offset;
>  next:
> -		vector += 8;
> +		vector += 16;
>  		if (vector >= first_system_vector) {
> -			/* If out of vectors on large boxen, must share them. */
> -			offset = (offset + 1) % 8;
> +			offset = (offset + 1) % 16;
>  			vector = FIRST_EXTERNAL_VECTOR + offset;
>  		}
>  		if (unlikely(current_vector == vector))
> -- 
> 1.7.7.6

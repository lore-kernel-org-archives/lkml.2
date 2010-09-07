Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab0IGFy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 01:54:58 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:53448 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752711Ab0IGFyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 01:54:52 -0400
Message-ID: <4C85D395.7040101@snapgear.com>
Date: Tue, 7 Sep 2010 15:54:29 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>
Subject: Re: [PATCH v2 13/24] ptrace: cleanup arch_ptrace() on m68knommu
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com> <1283442391-23612-14-git-send-email-namhyung@gmail.com>
In-Reply-To: <1283442391-23612-14-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Sep 2010 05:54:36.0154 (UTC) FILETIME=[26DD35A0:01CB4E51]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

Namhyung Kim wrote:
> Use new 'regno', 'datap' variables in order to remove duplicated
> expressions and unnecessary castings. Alse remove checking @addr
> less than 0 because addr is now unsigned.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Greg Ungerer <gerg@uclinux.org>

Looks ok to me:

Acked-by: Greg Ungerer <gerg@uclinux.org>


> ---
>  arch/m68knommu/kernel/ptrace.c |   58 ++++++++++++++++++---------------------
>  1 files changed, 27 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/m68knommu/kernel/ptrace.c b/arch/m68knommu/kernel/ptrace.c
> index 4ab9448..342baab 100644
> --- a/arch/m68knommu/kernel/ptrace.c
> +++ b/arch/m68knommu/kernel/ptrace.c
> @@ -115,6 +115,8 @@ long arch_ptrace(struct task_struct *child, long request,
>  		 unsigned long addr, unsigned long data)
>  {
>  	int ret;
> +	int regno = addr >> 2;
> +	unsigned long __user *datap = (unsigned long __user *) data;
>  
>  	switch (request) {
>  		/* read the word at location addr in the USER area. */
> @@ -122,71 +124,66 @@ long arch_ptrace(struct task_struct *child, long request,
>  			unsigned long tmp;
>  			
>  			ret = -EIO;
> -			if ((addr & 3) || addr < 0 ||
> -			    addr > sizeof(struct user) - 3)
> +			if ((addr & 3) || addr > sizeof(struct user) - 3)
>  				break;
>  			
>  			tmp = 0;  /* Default return condition */
> -			addr = addr >> 2; /* temporary hack. */
>  			ret = -EIO;
> -			if (addr < 19) {
> -				tmp = get_reg(child, addr);
> -				if (addr == PT_SR)
> +			if (regno < 19) {
> +				tmp = get_reg(child, regno);
> +				if (regno == PT_SR)
>  					tmp >>= 16;
> -			} else if (addr >= 21 && addr < 49) {
> -				tmp = child->thread.fp[addr - 21];
> +			} else if (regno >= 21 && regno < 49) {
> +				tmp = child->thread.fp[regno - 21];
>  #ifdef CONFIG_M68KFPU_EMU
>  				/* Convert internal fpu reg representation
>  				 * into long double format
>  				 */
> -				if (FPU_IS_EMU && (addr < 45) && !(addr % 3))
> +				if (FPU_IS_EMU && (regno < 45) && !(regno % 3))
>  					tmp = ((tmp & 0xffff0000) << 15) |
>  					      ((tmp & 0x0000ffff) << 16);
>  #endif
> -			} else if (addr == 49) {
> +			} else if (regno == 49) {
>  				tmp = child->mm->start_code;
> -			} else if (addr == 50) {
> +			} else if (regno == 50) {
>  				tmp = child->mm->start_data;
> -			} else if (addr == 51) {
> +			} else if (regno == 51) {
>  				tmp = child->mm->end_code;
>  			} else
>  				break;
> -			ret = put_user(tmp,(unsigned long *) data);
> +			ret = put_user(tmp, datap);
>  			break;
>  		}
>  
>  		case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
>  			ret = -EIO;
> -			if ((addr & 3) || addr < 0 ||
> -			    addr > sizeof(struct user) - 3)
> +			if ((addr & 3) || addr > sizeof(struct user) - 3)
>  				break;
>  
> -			addr = addr >> 2; /* temporary hack. */
> -			    
> -			if (addr == PT_SR) {
> +			if (regno == PT_SR) {
>  				data &= SR_MASK;
>  				data <<= 16;
>  				data |= get_reg(child, PT_SR) & ~(SR_MASK << 16);
>  			}
> -			if (addr < 19) {
> -				if (put_reg(child, addr, data))
> +			if (regno < 19) {
> +				if (put_reg(child, regno, data))
>  					break;
>  				ret = 0;
>  				break;
>  			}
> -			if (addr >= 21 && addr < 48)
> +			if (regno >= 21 && regno < 48)
>  			{
>  #ifdef CONFIG_M68KFPU_EMU
>  				/* Convert long double format
>  				 * into internal fpu reg representation
>  				 */
> -				if (FPU_IS_EMU && (addr < 45) && !(addr % 3)) {
> +				if (FPU_IS_EMU && (regno < 45) && !(regno % 3)) {
>  					data <<= 15;
>  					data = (data & 0xffff0000) |
>  					       ((data & 0x0000ffff) >> 1);
>  				}
>  #endif
> -				child->thread.fp[addr - 21] = data;
> +				child->thread.fp[regno - 21] = data;
>  				ret = 0;
>  			}
>  			break;
> @@ -198,11 +195,11 @@ long arch_ptrace(struct task_struct *child, long request,
>  			    tmp = get_reg(child, i);
>  			    if (i == PT_SR)
>  				tmp >>= 16;
> -			    if (put_user(tmp, (unsigned long *) data)) {
> +			    if (put_user(tmp, datap)) {
>  				ret = -EFAULT;
>  				break;
>  			    }
> -			    data += sizeof(unsigned long);
> +			    datap++;
>  			}
>  			ret = 0;
>  			break;
> @@ -212,7 +209,7 @@ long arch_ptrace(struct task_struct *child, long request,
>  			int i;
>  			unsigned long tmp;
>  			for (i = 0; i < 19; i++) {
> -			    if (get_user(tmp, (unsigned long *) data)) {
> +			    if (get_user(tmp, datap)) {
>  				ret = -EFAULT;
>  				break;
>  			    }
> @@ -222,7 +219,7 @@ long arch_ptrace(struct task_struct *child, long request,
>  				tmp |= get_reg(child, PT_SR) & ~(SR_MASK << 16);
>  			    }
>  			    put_reg(child, i, tmp);
> -			    data += sizeof(unsigned long);
> +			    datap++;
>  			}
>  			ret = 0;
>  			break;
> @@ -231,7 +228,7 @@ long arch_ptrace(struct task_struct *child, long request,
>  #ifdef PTRACE_GETFPREGS
>  		case PTRACE_GETFPREGS: { /* Get the child FPU state. */
>  			ret = 0;
> -			if (copy_to_user((void *)data, &child->thread.fp,
> +			if (copy_to_user(datap, &child->thread.fp,
>  					 sizeof(struct user_m68kfp_struct)))
>  				ret = -EFAULT;
>  			break;
> @@ -241,7 +238,7 @@ long arch_ptrace(struct task_struct *child, long request,
>  #ifdef PTRACE_SETFPREGS
>  		case PTRACE_SETFPREGS: { /* Set the child FPU state. */
>  			ret = 0;
> -			if (copy_from_user(&child->thread.fp, (void *)data,
> +			if (copy_from_user(&child->thread.fp, datap,
>  					   sizeof(struct user_m68kfp_struct)))
>  				ret = -EFAULT;
>  			break;
> @@ -249,8 +246,7 @@ long arch_ptrace(struct task_struct *child, long request,
>  #endif
>  
>  	case PTRACE_GET_THREAD_AREA:
> -		ret = put_user(task_thread_info(child)->tp_value,
> -			       (unsigned long __user *)data);
> +		ret = put_user(task_thread_info(child)->tp_value, datap);
>  		break;
>  
>  		default:


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com

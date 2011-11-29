Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab1K2UtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 15:49:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40283 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab1K2UtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:49:17 -0500
Message-ID: <4ED54547.5060905@canonical.com>
Date: Tue, 29 Nov 2011 14:49:11 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 3/3] prctl: Add PR_SET_MM codes to tune up mm_struct entires
References: <20111129191252.769160532@openvz.org> <20111129191638.912537377@openvz.org> <20111129201938.GP5169@outflux.net> <20111129202951.GG1775@moon>
In-Reply-To: <20111129202951.GG1775@moon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 02:29 PM, Cyrill Gorcunov wrote:
> On Tue, Nov 29, 2011 at 12:19:38PM -0800, Kees Cook wrote:
>> On Tue, Nov 29, 2011 at 11:12:55PM +0400, Cyrill Gorcunov wrote:
>>> At restore time we need a mechanism to restore those values
>>> back and for this sake PR_SET_MM prctl code is introduced.
>>>
>>> Note at moment this inteface is allowed for CAP_SYS_ADMIN
>>> only.
>>
>> NAK from me; this needs more bounds checking. Though, yes, it absolutely
>> must be a privileged action since this is potentially very dangerous. Can
>> we invent something stronger than CAP_SYS_ADMIN? ;)
>
> Heh.
>
>>
>>> @@ -1841,6 +1841,58 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
>>>   			else
>>>   				error = PR_MCE_KILL_DEFAULT;
>>>   			break;
>>> +		case PR_SET_MM: {
>>> +			struct mm_struct *mm;
>>> +			struct vm_area_struct *vma;
>>> +
>>> +			if (arg4 | arg5)
>>> +				return -EINVAL;
>>> +
>>> +			if (!capable(CAP_SYS_ADMIN))
>>> +				return -EPERM;
>>> +
>>> +			error = -ENOENT;
>>> +			mm = get_task_mm(current);
>>> +			if (!mm)
>>> +				return error;
>>> +
>>> +			down_read(&mm->mmap_sem);
>>> +			vma = find_vma(mm, arg3);
>>> +			if (!vma)
>>> +				goto out;
>>
>> arg3 needs to be significantly more carefully validated. find_vma() doesn't
>> say that vm_start<= addr, only that vm_end>  addr. This effectively
>> bypasses all the vma checks (mmap_min_addr, max process size, etc), with
>> some pretty crazy side-effects, I think.
>>
>
> Yes, I know it needs some more testing, but apart from vma bounds (yup,
> good point with find_vma, I'll fix) I thought about what else should be
> checked? I think VMA prototype should be checked to fit "code", "data"
> templates, ie code should be at least readable and execytable, but what
> about data and stack and brk, should stack be executable? That is the
> point where I've got a bit confused and though putting RFC out might be
> a good idea to collect opinions.

My memory is a bit hazy here, but cryo 
(http://git.sr71.net/?p=cryo-forhallyn.git;a=summary) did also do this 
from userspace.  As I recall the one problem we had was ... that we 
couldn't lower the mm_start of the first segment?  I think.  But I bring 
it up only because the advantage of doing it this way was that all of 
the ptrace protections automatically applied.

-serge

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab2A0Uae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:30:34 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:44057 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab2A0Uad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:30:33 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: gorcunov@openvz.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, xemul@openvz.org, xemul@parallels.com,
        avagin@openvz.org, kosaki.motohiro@gmail.com, mingo@elte.hu,
        hpa@zytor.com, tglx@linutronix.de, glommer@parallels.com,
        andi@firstfloor.org, tj@kernel.org, matthltc@us.ibm.com,
        penberg@kernel.org, eric.dumazet@gmail.com, segoon@openwall.com,
        adobriyan@gmail.com, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC c/r 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
References: <20120127175342.273260614@openvz.org>
	<20120127175939.795551339@openvz.org>
	<4F2306BB.5090907@jp.fujitsu.com>
Date: Fri, 27 Jan 2012 12:33:07 -0800
In-Reply-To: <4F2306BB.5090907@jp.fujitsu.com> (KOSAKI Motohiro's message of
	"Fri, 27 Jan 2012 15:19:07 -0500")
Message-ID: <m1aa5828e4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+wZ0+8KgrWqqIfSVLunMDgSMF4kWnNzBM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:

> On 1/27/2012 12:53 PM, Cyrill Gorcunov wrote:
>> +	switch (type) {
>> +	case KCMP_FILE: {
>> +		struct file *filp1, *filp2;
>> +
>> +		filp1 = get_file_raw_ptr(task1, idx1);
>> +		filp2 = get_file_raw_ptr(task2, idx2);
>> +
>> +		if (filp1 && filp2)
>> +			ret = kcmp_ptr((long)filp1, (long)filp2, KCMP_FILE);
>> +		else
>> +			ret = -ENOENT;
>
> If my remember is correct, Andrew pointed out EINVAL is better than ENOENT.

Ah yes.  And really what it should be is
		if (!filp1 || !filp2)
 			return -EBADF;

At least EBADF is what you return if it is your process that doesn't
have the filedescriptor.

>> +		break;
>> +	case KCMP_SYSVSEM:
>> +#ifdef CONFIG_SYSVIPC
>> +		ret = kcmp_ptr((long)task1->sysvsem.undo_list,
>> +			       (long)task2->sysvsem.undo_list,
>> +			       KCMP_SYSVSEM);
>> +#else
>> +		ret = -EINVAL;
>
> ENOTSUP is better, I think. because of, EINVAL implicitly mean _caller_ is wrong.
> but in this case, it is not bad. only the kernel doesn't have enough
> feature.

Careful a type compiled out should in principle match a type whose
support has not been implemented. That is the default case should match
what happens when you don't compile in sysvipc support.

>
>> +		goto err;
>
> you don't need err label at all.
>
>
>> +#endif
>> +		break;
>> +	default:
>> +		ret = -EINVAL;
>> +		goto err;
>> +	}
>> +
>> +err:
>> +	put_task_struct(task1);
>> +	put_task_struct(task2);
>> +
>> +	return ret;
>> +}

Eric

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab2A0VQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:16:47 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:53572 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2A0VQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:16:46 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        xemul@openvz.org, xemul@parallels.com, avagin@openvz.org,
        kosaki.motohiro@gmail.com, mingo@elte.hu, hpa@zytor.com,
        tglx@linutronix.de, glommer@parallels.com, andi@firstfloor.org,
        tj@kernel.org, matthltc@us.ibm.com, penberg@kernel.org,
        eric.dumazet@gmail.com, segoon@openwall.com, adobriyan@gmail.com,
        Valdis.Kletnieks@vt.edu
Subject: Re: [RFC c/r 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
References: <20120127175342.273260614@openvz.org>
	<20120127175939.795551339@openvz.org>
	<4F2306BB.5090907@jp.fujitsu.com> <m1aa5828e4.fsf@fess.ebiederm.org>
	<20120127205026.GT11086@moon>
Date: Fri, 27 Jan 2012 13:19:20 -0800
In-Reply-To: <20120127205026.GT11086@moon> (Cyrill Gorcunov's message of "Sat,
	28 Jan 2012 00:50:26 +0400")
Message-ID: <m1bopozvvr.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18q6yicJTqtWnb+de6o2KnEtxL1PM8Fxgk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@openvz.org> writes:

> On Fri, Jan 27, 2012 at 12:33:07PM -0800, Eric W. Biederman wrote:
>> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:
>> >> +			ret = kcmp_ptr((long)filp1, (long)filp2, KCMP_FILE);
>> >> +		else
>> >> +			ret = -ENOENT;
>> >
>> > If my remember is correct, Andrew pointed out EINVAL is better than ENOENT.
>> 
>> Ah yes.  And really what it should be is
>> 		if (!filp1 || !filp2)
>>  			return -EBADF;
>> 
>> At least EBADF is what you return if it is your process that doesn't
>> have the filedescriptor.
>> 
>
> Eric, I've sent out version with
>
> 		if (filp1 && filp2)
> 			...
> 		else
> 			ret = -EBADF;
>
> maybe you're lookin into previous version?

Yeah.  Comments and patch passing in the night.  It looks like you have
it right in your latest patch.

>> >> +			       KCMP_SYSVSEM);
>> >> +#else
>> >> +		ret = -EINVAL;
>> >
>> > ENOTSUP is better, I think. because of, EINVAL implicitly mean _caller_ is wrong.
>> > but in this case, it is not bad. only the kernel doesn't have enough
>> > feature.
>> 
>> Careful a type compiled out should in principle match a type whose
>> support has not been implemented. That is the default case should match
>> what happens when you don't compile in sysvipc support.
>
> I don't get it :) Will -EINVAL be enough or not?

At the present time the only way we can get -EINVAL by not supporting a
type so there is no pressing need for something different.

However in the general case EINVAL is a pretty generic failure mode and
having something more precise that you can use to figure out what you
did wrong when calling a system call tends to help a great deal.

So I am favor of using a better error code if EOPNOTSUP or ENOTTY if we
can convince ourselves it is the proper error code.

Mostly it is bike shedding but it is a detail that getting it right will
help users of this interface in the long run.

Eric

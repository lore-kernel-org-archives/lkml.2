Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab2A0SGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:06:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48784 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab2A0SGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:06:07 -0500
Message-ID: <4F22E75E.6090602@zytor.com>
Date: Fri, 27 Jan 2012 10:05:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC c/r 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
References: <20120127175342.273260614@openvz.org> <20120127175939.795551339@openvz.org>
In-Reply-To: <20120127175939.795551339@openvz.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 09:53 AM, Cyrill Gorcunov wrote:
> +
> +/*
> + * We don't expose real in-memory order of objects for security
> + * reasons, still the comparision results should be suitable for
> + * sorting. Thus, we obfuscate kernel pointers values (using random
> + * cookies obtaned at early boot stage) and compare the production
> + * instead.
> + */
> +static unsigned long cookies[KCMP_TYPES][2] __read_mostly;
> +
> +static long kptr_obfuscate(long v, int type)
> +{
> +	return (v ^ cookies[type][0]) * cookies[type][1];
> +}
> +
> +/*
> + * 0 - equal
> + * 1 - less than
> + * 2 - greater than
> + * 3 - not equal but ordering unavailable (reserved for future)
> + */
> +static int kcmp_ptr(long v1, long v2, enum kcmp_type type)
> +{
> +	long ret;
> +
> +	ret = kptr_obfuscate(v1, type) - kptr_obfuscate(v2, type);
> +
> +	return (ret < 0) | ((ret > 0) << 1);
> +}
> +

I just want to point out that we could do hard cryptography, too --
using DES or AES and compare the result since symmetric cryptography is
an isomorphism.  One would have to compare the whole result, obviously,
not a truncated one, so using memcmp() or the similar.

I'll leave it up to the security guys to worry about if that is needed,
but since it is something that can be slotted in without changing the
API it seems reasonably safe.

	-hpa

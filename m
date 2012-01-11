Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab2AKUAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:00:07 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:8859 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757999Ab2AKUAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:00:03 -0500
Message-ID: <4F0DE99B.3050803@parallels.com>
Date: Wed, 11 Jan 2012 23:57:15 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyle Moffett <kyle@moffetthome.net>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [RFC] on general object IDs again
References: <20120111161939.GI8752@moon> <CAHGf_=r1vrZbCTYNAp7e+Hbbxh2BnDXXrdsNckSkQVVrXQ=9KQ@mail.gmail.com> <20120111175952.GI466@moon> <CAHGf_=oMk2YDnmsomgCc45Ei5yaSdNzRwapm7Fqm9mN7LY0FNw@mail.gmail.com> <4F0DD365.6070200@parallels.com> <20120111183115.GA28196@moon> <CAHGf_=oXsrbsXPqBw_CvZQjwdXhzhqkoWX3mRSEgMZHy44ZUKg@mail.gmail.com> <4F0DE4B0.4070800@parallels.com> <CAHGf_=qs+-YZ-XFx5FyWMhF4Dee3_bCGJXGmKkQ0_ED75KxxOQ@mail.gmail.com>
In-Reply-To: <CAHGf_=qs+-YZ-XFx5FyWMhF4Dee3_bCGJXGmKkQ0_ED75KxxOQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2012 11:50 PM, KOSAKI Motohiro wrote:
>> This might work for mm_structs, although quite a lot apps now do have threads and
>> this mm->users check will be negative. But how about open files? Once we entered the
>> get-the-youngest-file-owner routine we need to take locks and with 1000 tasks the
>> overhead is not 1000 syscalls, but 1000 (syscalls + locks).
> 
> Unfortunately, I have no knowledge your program have what assumption
> of file modify. When I reviewed mincore patch from you, you said you
> assume any file are preserved. And If nobody change the files, why do
> we need to care file locks? I have no knowledge a grand picture of
> your design at all.

By locking I mean the internal kernel locks that preserve kernel objects
integrity. E.g. to check for a task's file (the struct file) being the one
you're interested in you need to lock the task lock (call the task_lock(p))
in order to get the fdtable pointer.

By the way, if you have a file and want to have its ID the complexity is not
just O(N^2) for N tasks. For each task you should walk the whole fdtable which
just makes things worse.

That said, I'd stick to the IDs that are calculated out of the object pointer.

Thanks,
Pavel

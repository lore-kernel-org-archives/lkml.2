Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab2JQFz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 01:55:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40310 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752979Ab2JQFzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 01:55:24 -0400
X-IronPort-AV: E=Sophos;i="4.80,598,1344182400"; 
   d="scan'208";a="6013784"
Message-ID: <507E48ED.8060809@cn.fujitsu.com>
Date: Wed, 17 Oct 2012 13:58:05 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] percpu-rwsem: use barrier in unlock path
References: <Pine.LNX.4.64.1210151716310.10685@file.rdu.redhat.com> <Pine.LNX.4.64.1210161924350.20581@file.rdu.redhat.com> <CA+55aFyZ9uq_yfHn9PwpmM77X3xVd+xseEbjJmeCCqbFddtjWA@mail.gmail.com>
In-Reply-To: <CA+55aFyZ9uq_yfHn9PwpmM77X3xVd+xseEbjJmeCCqbFddtjWA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/17 13:55:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/17 13:55:02,
	Serialize complete at 2012/10/17 13:55:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 10:23 AM, Linus Torvalds wrote:
> [ Architecture people, note the potential new SMP barrier! ]
> 
> On Tue, Oct 16, 2012 at 4:30 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>> +       /*
>> +        * The lock is considered unlocked when p->locked is set to false.
>> +        * Use barrier prevent reordering of operations around p->locked.
>> +        */
>> +#if defined(CONFIG_X86) && (!defined(CONFIG_X86_PPRO_FENCE) && !defined(CONFIG_X86_OOSTORE))
>> +       barrier();
>> +#else
>> +       smp_mb();
>> +#endif
>>         p->locked = false;
> 
> Ugh. The #if is too ugly to live.

Even the previous patch is applied, percpu_down_read() still
needs mb() to pair with it.

> 
> This is a classic case of "people who write their own serialization
> primitives invariably get them wrong". And this fix is just horrible,
> and code like this should not be allowed.

One of the most major problems of 62ac665ff9fc07497ca524bd20d6a96893d11071 is that
it is merged without Ackeds or Revieweds from Paul or Peter or someone else
who are expert at synchronization/arch memory models.

I suggest any new synchronization should stay in -tip for 2 or more cycles
before merged to mainline.

Thanks,
Lai

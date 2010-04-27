Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab0D0R6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 13:58:33 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:54135 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab0D0R6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 13:58:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a4PQjC3XX0bXGWlyPtk+u40Rg5s4LRcRfsQSCV/umZzeVX8wtxOcxSlL+EQoc29TIO
         YYsV4rX/2YiXagFeuH0zLF/ry6ETRNU4IxrkRwRZtS/OHJnMAySBwYLb27Usd9mwWZSg
         EohPqCuAQ6QdiyemzDroCBPdNnkFE0SDTBWsc=
MIME-Version: 1.0
In-Reply-To: <20100427162201.GA5826@linux.vnet.ibm.com>
References: <20100422160144.GC2524@linux.vnet.ibm.com>
	 <20100423194255.GE2589@linux.vnet.ibm.com>
	 <m2xa44ae5cd1004231559hcf90671asf146a43b4748c2c3@mail.gmail.com>
	 <20100425023455.GM2440@linux.vnet.ibm.com>
	 <w2sa44ae5cd1004250849q73704370vc6af935c70db9b73@mail.gmail.com>
	 <p2ga44ae5cd1004251320j55d23ba7ua0fa14497f623d76@mail.gmail.com>
	 <20100426160925.GD2529@linux.vnet.ibm.com>
	 <m1hbmydpup.fsf@fess.ebiederm.org>
	 <20100427042744.GD2510@linux.vnet.ibm.com>
	 <20100427162201.GA5826@linux.vnet.ibm.com>
Date: Tue, 27 Apr 2010 13:58:30 -0400
Message-ID: <g2ya44ae5cd1004271058p9f73fba1v3f611693e81869c3@mail.gmail.com>
Subject: Re: [PATCH] RCU: don't turn off lockdep when find suspicious 
	rcu_dereference_check() usage
From: Miles Lane <miles.lane@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>, Eric Paris <eparis@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, nauman@google.com,
       eric.dumazet@gmail.com, netdev@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 12:22 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Mon, Apr 26, 2010 at 09:27:44PM -0700, Paul E. McKenney wrote:
>> On Mon, Apr 26, 2010 at 11:35:10AM -0700, Eric W. Biederman wrote:
>> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
>> >
>> > > Eric Dumazet traced these down to a commit from Eric Biederman.
>> > >
>> > > If I don't hear from Eric Biederman in a few days, I will attempt a
>> > > patch, but it would be more likely to be correct coming from someone
>> > > with a better understanding of the code.  ;-)
>> >
>> > I already replied.
>> >
>> > http://lkml.org/lkml/2010/4/21/420
>>
>> You did indeed!!!  This experience is giving me an even better appreciation
>> of the maintainers' ability to keep all their patches straight!
>>
>> I will put together something based on your suggestion.
>
> How about the following?
>
>                                                        Thanx, Paul
>
> ------------------------------------------------------------------------
>
> commit 85fa42bd568ab99c375f018761ae6345249942cd
> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Date:   Mon Apr 26 21:40:05 2010 -0700
>
>    net: suppress RCU lockdep false positive in twsk_net()
>
>    Calls to twsk_net() are in some cases protected by reference counting
>    as an alternative to RCU protection.  Cases covered by reference counts
>    include __inet_twsk_kill(), inet_twsk_free(), inet_twdr_do_twkill_work(),
>    inet_twdr_twcal_tick(), and tcp_timewait_state_process().  RCU is used
>    by inet_twsk_purge().  Locking is used by established_get_first()
>    and established_get_next().  Finally, __inet_twsk_hashdance() is an
>    initialization case.
>
>    It appears to be non-trivial to locate the appropriate locks and
>    reference counts from within twsk_net(), so used rcu_dereference_raw().
>
>    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>
> diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
> index 79f67ea..a066fdd 100644
> --- a/include/net/inet_timewait_sock.h
> +++ b/include/net/inet_timewait_sock.h
> @@ -224,7 +224,9 @@ static inline
>  struct net *twsk_net(const struct inet_timewait_sock *twsk)
>  {
>  #ifdef CONFIG_NET_NS
> -       return rcu_dereference(twsk->tw_net);
> +       return rcu_dereference_raw(twsk->tw_net); /* protected by locking, */
> +                                                 /* reference counting, */
> +                                                 /* initialization, or RCU. */
>  #else
>        return &init_net;
>  #endif
>

Worked for me.  Thanks!

           Miles

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab1EGWAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 18:00:52 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45177 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab1EGWAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 18:00:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HGS6w/J4t1VAX3mHuB66kernUTEShH3jgQZplLeldRfSr0yNVP07GVJC7/DYNFmWxz
         YzvCuyvMA8Arko3ilAMGOeUiSbEcLUuN98HzNtv7f4XALB3UbhKEray3mZt7iFFdnbCq
         udU86q3zozn4VGvWC3Kdy1TvR/kB2+MyZNltk=
MIME-Version: 1.0
In-Reply-To: <BANLkTikKhjmPJKHiJa2hRBdUF2=oe8HZzg@mail.gmail.com>
References: <1304366849.15370.27.camel@mulgrave.site>
	<20110502224838.GB10278@cmpxchg.org>
	<BANLkTikKhjmPJKHiJa2hRBdUF2=oe8HZzg@mail.gmail.com>
Date: Sun, 8 May 2011 03:30:48 +0530
X-Google-Sender-Auth: lYQb8OUkRP83xTmy6IPtx2ZbghE
Message-ID: <BANLkTik2npu-b1AnLx_tyrhLZ366CkWSTQ@mail.gmail.com>
Subject: Re: memcg: fix fatal livelock in kswapd
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Chris Mason <chris.mason@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, my mailer might have used intelligence to send HTML (that is
what happens when the setup changes, I apologize). Resending in text
format

On Sun, May 8, 2011 at 3:29 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>
> On Tue, May 3, 2011 at 4:18 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>>
>> Hi,
>>
>> On Mon, May 02, 2011 at 03:07:29PM -0500, James Bottomley wrote:
>> > The fatal livelock in kswapd, reported in this thread:
>> >
>> > http://marc.info/?t=130392066000001
>> >
>> > Is mitigateable if we prevent the cgroups code being so aggressive in
>> > its zone shrinking (by reducing it's default shrink from 0 [everything]
>> > to DEF_PRIORITY [some things]).  This will have an obvious knock on
>> > effect to cgroup accounting, but it's better than hanging systems.
>>
>> Actually, it's not that obvious.  At least not to me.  I added Balbir,
>> who added said comment and code in the first place, to CC: Here is the
>> comment in full quote:
>>
>
> I missed this email in my inbox, just saw it and responding
>
>>
>>        /*
>>         * NOTE: Although we can get the priority field, using it
>>         * here is not a good idea, since it limits the pages we can scan.
>>         * if we don't reclaim here, the shrink_zone from balance_pgdat
>>         * will pick up pages from other mem cgroup's as well. We hack
>>         * the priority and make it zero.
>>         */
>>
>> The idea is that if one memcg is above its softlimit, we prefer
>> reducing pages from this memcg over reclaiming random other pages,
>> including those of other memcgs.
>>
>
> My comment and code were based on the observations I saw during my tests.
> With DEF_PRIORITY we see scan >> priority in get_scan_count(), since we know
> how much exactly we are over the soft limit, it makes sense to go after the
> pages, so that normal balancing can be restored.
>
>>
>> But the code flow looks like this:
>>
>>        balance_pgdat
>>          mem_cgroup_soft_limit_reclaim
>>            mem_cgroup_shrink_node_zone
>>              shrink_zone(0, zone, &sc)
>>          shrink_zone(prio, zone, &sc)
>>
>> so the success of the inner memcg shrink_zone does at least not
>> explicitely result in the outer, global shrink_zone steering clear of
>> other memcgs' pages.
>
> Yes, but it allows soft reclaim to know what to target first for success
>
>>
>>  It just tries to move the pressure of balancing
>> the zones to the memcg with the biggest soft limit excess.  That can
>> only really work if the memcg is a large enough contributor to the
>> zone's total number of lru pages, though, and looks very likely to hit
>> the exceeding memcg too hard in other cases.
>>
>> I am very much for removing this hack.  There is still more scan
>> pressure applied to memcgs in excess of their soft limit even if the
>> extra scan is happening at a sane priority level.  And the fact that
>> global reclaim operates completely unaware of memcgs is a different
>> story.
>>
>> However, this code came into place with v2.6.31-8387-g4e41695.  Why is
>> it only now showing up?
>>
>> You also wrote in that thread that this happens on a standard F15
>> installation.  On the F15 I am running here, systemd does not
>> configure memcgs, however.  Did you manually configure memcgs and set
>> soft limits?  Because I wonder how it ended up in soft limit reclaim
>> in the first place.
>>
>
> I am running F15 as well, but never hit the problem so far. I am surprised
> to see the stack posted on the thread, it seemed like you
> never explicitly enabled anything to wake up the memcg beast :)
> Balbir

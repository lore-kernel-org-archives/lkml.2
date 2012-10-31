Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab2JaRUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:20:11 -0400
Received: from mx2.parallels.com ([64.131.90.16]:53634 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758618Ab2JaRUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:20:08 -0400
Message-ID: <50915DB7.5020706@parallels.com>
Date: Wed, 31 Oct 2012 21:19:51 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Michal Hocko <mhocko@suse.cz>, <lizefan@huawei.com>, <hannes@cmpxchg.org>,
        <bsingharora@gmail.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] cgroup: kill CSS_REMOVED
References: <1351657365-25055-1-git-send-email-tj@kernel.org> <1351657365-25055-3-git-send-email-tj@kernel.org> <20121031153926.GC22809@dhcp22.suse.cz> <20121031165739.GE2945@htj.dyndns.org> <50915A87.4070504@parallels.com> <CAOS58YP=CjTPFdETLRXnc3gXEzX2=EEe2dMdSh3Eov7zRfV4Qg@mail.gmail.com>
In-Reply-To: <CAOS58YP=CjTPFdETLRXnc3gXEzX2=EEe2dMdSh3Eov7zRfV4Qg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.39.244.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 09:10 PM, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Wed, Oct 31, 2012 at 10:06 AM, Glauber Costa <glommer@parallels.com> wrote:
>> This is not the topic of this thread, but since you brought it:
>> If you take a look at the description patch in the patch I sent, the
>> problem I outlined is that at create time, we don't know anything about
>> which will the css_id be - and I would like to avoid creating yet
>> another index.
>>
>> Is there any way you would suggest of handling this ? Any chance of us
>> allocating the css_id earlier then?
> 
> I only glanced the patch description but the problem I'm trying to
> solve is locking - currently we don't have a place where a controller
> can tell a cgroup is becoming online; thus it has nothing to
> synchronized against and tell that a cgroup is alive or not.  As for
> css_id allocation, maybe you can deal with that in ->post_create() or
> maybe we can allocate css_id earlier (but where would it be stored?).
> I'll look into it.
> 

The css_id is allocated right after ->create(). So if post_create() is
called after that, I can use it just fine - which is what I do in my
patch. Problem is, since I do memory allocation based on that, it can fail.

So although I would have to look at your series myself to see exactly
what you are trying to achieve (looking forward), I seemed natural to me
to think about it terms of "early_create" + "late_create" (->create())
and ->post_create()), where the later is a callback when things are
readier (in this case, the css_id).

I don't see post_create failing as a huge problem. The natural
synchronization point would be "right after post_create" - then you can
definitely tell that it is online. Although this can be viewed a bit as
"exposing internals", creating is different then destroying: When you
create, you may not have all data yet. When destroying, you do - and
want to get rid of it. So this kind of bootstrapping is pretty standard
and common.




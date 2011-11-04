Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1KDNMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 09:12:39 -0400
Received: from mx2.parallels.com ([64.131.90.16]:58930 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab1KDNMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 09:12:37 -0400
Message-ID: <4EB3E47E.2080003@parallels.com>
Date: Fri, 4 Nov 2011 11:11:26 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: "Brian K. White" <brian@aljex.com>, <cgroups@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <max@duempel.org>
Subject: Re: [PATCH] new cgroup controller "fork"
References: <20111103162238.27609.11515.stgit@rabbit.intern.cm-ag>	<4EB2C4A5.6000406@parallels.com>	<20111103165903.GA4755@Debian-60-squeeze-64-minimal>	<20111103182101.5037c1e5@lxorguk.ukuu.org.uk>	<20111103185108.GA5153@Debian-60-squeeze-64-minimal>	<20111103190330.02590426@lxorguk.ukuu.org.uk>	<20111103192039.GA5300@Debian-60-squeeze-64-minimal>	<4EB2EA93.2050206@parallels.com> <4EB2F5CF.5010604@aljex.com> <4EB30DAF.4090704@parallels.com> <4EB3560D.7000002@cn.fujitsu.com>
In-Reply-To: <4EB3560D.7000002@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2011 01:03 AM, Li Zefan wrote:
> 于 2011年11月04日 05:54, Glauber Costa 写道:
>> On 11/03/2011 06:13 PM, Brian K. White wrote:
>>> On 11/3/2011 3:25 PM, Glauber Costa wrote:
>>>> On 11/03/2011 05:20 PM, Max Kellermann wrote:
>>>>> On 2011/11/03 20:03, Alan Cox<alan@lxorguk.ukuu.org.uk>  wrote:
>>>>>> Sure - I'm just not seeing that a whole separate cgroup for it is
>>>>>> appropriate or a good plan. Anyone doing real resource management needs
>>>>>> the rest of the stuff anyway.
>>>>>
>>>>> Right. When I saw Frederic's controller today, my first thought was
>>>>> that one could move the fork limit code over into that controller. If
>>>>> we reach a consensus that this would be a good idea, and would have
>>>>> chances to get merged, I could probably take some time to refactor my
>>>>> code.
>>>>>
>>>>> Max
>>>> I'd advise you to take a step back and think if this is really needed.
>>>> As Alan pointed out, the really expensive resource here is already being
>>>> constrained by Frederic's controller.
>>>
>>> I think this really is a different knob that is nice to have as long as
>>> it doesn't cost much. It's a way to set a max lifespan in a way that
>>> isn't really addressed by the other controls. (I could absolutely be
>>> missing something.)
>>>
>>> I think Max explained the issue clearly enough.
>>
>> He did, indeed.
>>
>>> It doesn't matter that the fork itself is supposedly so cheap.
>>>
>>> It's still nice to have a way to say, you may not fork/die/fork/die/fork
>>> in a race.
>>>
>>> What's so unimaginable about having a process that you know needs a lot
>>> of cpu and ram or other resources to do it's job, and you expressly want
>>> to allow it to take as much of those resources as it can, but you know
>>> it has no need to fork, so if it forks, _that_ is the only indication of
>>> a problem, so you may only want to block it based on that.
>>>
>>> Sure many other processes would legitimately fork/die/fork/die a lot
>>> while never exceeding a few total concurrent tasks, and for them you
>>> would not want to set any such fork limit. So what?
>>>
>> As I said previously, he knows his use cases better than anyone else.
>> If a use case can be found in which the summation of cpu+task controllers is not enough, and if this is implemented as an option to the task controller, and does not make it:
>> 1) confusing,
>> 2) more expensive,
>>
>> then I don't see why not we shouldn't take it.
>
> Quoted from Lennart's reply in another mail thread:
>
> "Given that shutting down some services might involve forking off a few
> things (think: a shell script handling shutdown which forks off a couple
> of shell utilities) we'd want something that is between "from now on no
> forking at all" and "unlimited forking". This could be done in many
> different ways: we'd be happy if we could do time-based rate limiting,
> but we'd also be fine with defining a certain budget of additional forks
> a cgroup can do (i.e. "from now on you can do 50 more forks, then you'll
> get EPERM)."
>
> (http://lkml.org/lkml/2011/10/19/468)
>
> The last sentence suggests he might like this fork controller.

Well, If I understand Frederic's work well enough, this can be achieved 
by setting the task limit to 0 in his controller. No?

Because being lower than your limit won't kick tasks out, the practical 
effect is that no forks will be allowed in the group with this setting.

So for time-based rate limiting, it is trivial to just set it to 0 after 
x seconds.

For other uses, we can watch the task counter increase until a certain 
value, and then set the limit to 0.

Max, wouldn't it be enough for your use?

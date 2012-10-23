Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab2JWTxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:53:19 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43316 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756884Ab2JWTxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:53:16 -0400
Message-ID: <5086F5A7.9090406@vlnb.net>
Date: Tue, 23 Oct 2012 15:53:11 -0400
From: Vladislav Bolkhovitin <vvvvvst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: =?UTF-8?B?5p2o6IuP56uLIFlhbmcgU3UgTGk=?= <suli@cs.wisc.edu>
CC: General Discussion of SQLite Database <sqlite-users@sqlite.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com> <m2fw5mtffg.fsf_-_@firstfloor.org> <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
In-Reply-To: <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

杨苏立 Yang Su Li, on 10/11/2012 12:32 PM wrote:
> I am not quite whether I should ask this question here, but in terms
> of light weight barrier/fsync, could anyone tell me why the device
> driver / OS provide the barrier interface other than some other
> abstractions anyway? I am sorry if this sounds like a stupid questions
> or it has been discussed before....
>
> I mean, most of the time, we only need some ordering in writes; not
> complete order, but partial,very simple topological order. And a
> barrier seems to be a heavy weighted solution to achieve this anyway:
> you have to finish all writes before the barrier, then start all
> writes issued after the barrier. That is some ordering which is much
> stronger than what we need, isn't it?
>
> As most of the time the order we need do not involve too many blocks
> (certainly a lot less than all the cached blocks in the system or in
> the disk's cache), that topological order isn't likely to be very
> complicated, and I image it could be implemented efficiently in a
> modern device, which already has complicated caching/garbage
> collection/whatever going on internally. Particularly, it seems not
> too hard to be implemented on top of SCSI's ordered/simple task mode?

Yes, SCSI has full support for ordered/simple commands designed exactly for that 
task: to have steady flow of commands even in case when some of them are ordered. 
It also has necessary facilities to handle commands errors without unexpected 
reorders of their subsequent commands (ACA, etc.). Those allow to get full storage 
performance by fully "fill the pipe", using networking terms. I can easily imaging 
real life configs, where it can bring 2+ times more performance, than with queue 
flushing.

In fact, AFAIK, AIX requires from storage to support ordered commands and ACA.

Implementation should be relatively easy as well, because all transports naturally 
have link as the point of serialization, so all you need in multithreaded 
environment is to pass some SN from the point when each ORDERED command created to 
the point when it sent to the link and make sure that no SIMPLE commands can ever 
cross ORDERED commands. You can see how it is implemented in SCST in an elegant 
and lockless manner (for SIMPLE commands).

But historically for some reason Linux storage developers were stuck with 
"barriers" concept, which is obviously not the same as ORDERED commands, hence had 
a lot troubles with their ambiguous semantic. As far as I can tell the reason of 
that was some lack of sufficiently deep SCSI understanding (how to handle errors, 
believe that ACA is something legacy from parallel SCSI times, etc.).

Hopefully, eventually the storage developers will realize the value behind ordered 
commands and learn corresponding SCSI facilities to deal with them. It's quite 
easy to demonstrate this value, if you know where to look at and not blindly 
refusing such possibility. I have already tried to explain it a couple of times, 
but was not successful.

Before that happens, people will keep returning again and again with those simple 
questions: why the queue must be flushed for any ordered operation? Isn't is an 
obvious overkill?

Vlad

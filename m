Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab1AaVr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:47:26 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50610 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab1AaVrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:47:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=bRhiXtrfsAsG3LqpkSjBi8lJC1RssKtTiDAGL2uO1hl53jKpTfjYKiqBq0I9MVp1bS
         DpM4sTevShNps/MWU935aLysQJphS31rrMOl8IqdArPVInUwnFKSk1DoI+D2tGQP2nVO
         fXzzvipIfzgUVKVh8rJk8IumduWoNjCiXaDZE=
MIME-Version: 1.0
Date: Mon, 31 Jan 2011 13:47:23 -0800
Message-ID: <AANLkTimJDat+OdZgEdZu2FPbzJV2t_Q3NEG9w=WxbvZ9@mail.gmail.com>
Subject: Help? sendfile() blocked in sk_stream_wait_memory()
From: "Patrick J. LoPresti" <lopresti@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.  I have a client/server application that has been working fine
for years on dozens of systems deployed in the field.

I am working on upgrading our systems to newer versions of hardware
and Linux, and now my application is occasionally hanging in
sendfile().  The hang is moderately hard to reproduce.

My kernel version is 2.6.32.27-0.2-default (Suse 11 SP1 latest
update).  I am working this problem though Suse, but I am hoping
someone here could kindly give me some pointers as well.

Here is the backtrace from /proc/<pid>/stack:

[<ffffffff812efdc8>] sk_stream_wait_memory+0x1a8/0x250
[<ffffffff8132c9b9>] do_tcp_sendpages+0x209/0x500
[<ffffffff8132cd3e>] tcp_sendpage+0x8e/0xa0
[<ffffffff812e2446>] kernel_sendpage+0x16/0x30
[<ffffffff812e2495>] sock_sendpage+0x35/0x40
[<ffffffff8111f12f>] pipe_to_sendpage+0x5f/0x90
[<ffffffff8111f1cd>] splice_from_pipe_feed+0x6d/0x120
[<ffffffff8111f74e>] __splice_from_pipe+0x5e/0x80
[<ffffffff8111f7be>] splice_from_pipe+0x4e/0x70
[<ffffffff8111fcfb>] direct_splice_actor+0x1b/0x20
[<ffffffff81120474>] splice_direct_to_actor+0xe4/0x1c0
[<ffffffff8112059b>] do_splice_direct+0x4b/0x70
[<ffffffff810fd02e>] do_sendfile+0x19e/0x210
[<ffffffff810fd12e>] sys_sendfile64+0x8e/0xb0
[<ffffffff81002f7b>] system_call_fastpath+0x16/0x1b

(Briefly, the client uses sendfile() to push data to the server, which
uses recv() to receive it.)

Using gdb, I have verified that the client is blocked in sendfile()
and the server is blocked in recv() on the socket between them.

I have disassembled my vmlinux to verify that
sk_stream_wait_memory+0x1a8/0x250 is the address following a call to
schedule_timeout(), as one might expect.

netstat shows both sides of the socket in "CONNECTED" state.

I have hammered the network connection between these systems pretty
hard and it is not showing any problems that I can discern.  (This is
a 10GigE connection, for what it is worth.)  I am working on building
a duplicate system to help verify that it is not a hardware problem.

My question is this:  What is my next step for debugging this?  As far
as I can tell, the socket has just sort of...  "stopped", for no
apparent reason.  I am not afraid to add some instrumentation to my
kernel, but I do not understand the socket code well enough even to
know where to begin.

Alternatively, any ideas for changes I could make to my system
configuration or application (e.g., adjusting sndbuf size?), even if
it were just a work-around and not a fix, would be appreciated.

Thanks.

 - Pat

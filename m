Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab2INQFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:05:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34729 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab2INQFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:05:11 -0400
Message-ID: <505355AF.7000006@gmail.com>
Date: Fri, 14 Sep 2012 10:05:03 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>
CC: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@ghostprotocols.net, tzanussi@gmail.com
Subject: Re: perf script: rwtop: SIGALRM and pipe read race
References: <20120914153952.GA8834@turtle.usersys.redhat.com>
In-Reply-To: <20120914153952.GA8834@turtle.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/12 9:39 AM, Andrew Jones wrote:
>
> I recently tried 'perf script rwtop', and it immediately failed with
> 'failed to read event header'. Running it through strace I found that the
> when rwtop.pl is reading from the pipe, and gets one of it's alarms, that
> the ERESTARTSYS seems to confuse it - causing it to fail. It also appears
> that the problem only happens early in execution, or not at all. If I get
> lucky and don't hit the problem right away, then rwtop will run fine as
> long as I want, without any ERESTARTSYS's in its trace. I also found that
> I can avoid hitting the problem by throwing a 'pv -q' in front of the perf
> command in tools/perf/scripts/perl/bin/rwtop-report. Which I guess slows
> things down in the reader enough to always avoid the race.
>
> Sorry I don't have a solution (patch). I'll look at it more as time
> permits, but I thought I'd get it reported for starters though.


This fixes the run-time problem:

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 1b8775c..a4371ae 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -142,6 +142,9 @@ int readn(int fd, void *buf, size_t n)
     while (n) {
         int ret = read(fd, buf, n);

+        if ((ret < 0) && (errno == EINTR))
+            continue;
+
         if (ret <= 0)
             return ret;



The only problem you will find with rwtop is that bytes_read will be 
really whacky. I traced it to:

     if ($ret > 0) {
printf("comm %s bytes_read %d\n", $common_comm, $ret);
         $reads{$common_pid}{bytes_read} += $ret;

Somehow the $ret > 0 is passing when in fact it is negative. I do not 
know much about perl to fix it.

David

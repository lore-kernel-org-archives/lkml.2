Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab1EZWKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 18:10:25 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:52263 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731Ab1EZWKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 18:10:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=QKkr7yc1C9t3QlLQE1xEI8lqByFBm3tStxYtdgKPuCRldFMyYcvmWGW2bAaiiwEjpH
         VCDfUa++7wsCa/sY6mReuQTnkEzfesLJ5CsahBYaK0fihn3x+GawYoxLuOJMJLxR4gHY
         bYupJUdGYcYXcrALXDHNcGhFH0Jrg3pb9KqJU=
Message-ID: <4DDECFC8.7090903@gmail.com>
Date: Thu, 26 May 2011 16:10:16 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: perf: h/w counters not counted and no error/info reported to user
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


By default (tip-perf-core) perf-stat enables a number of H/W counters:

perf stat  -- sleep 1

Performance counter stats for 'sleep 1':

     1.346889 task-clock
            1 context-switches
            0 CPU-migrations
          157 page-faults
<not counted> cycles
<not counted> stalled-cycles-frontend
<not counted> stalled-cycles-backend
      493,740 instructions
      137,062 branches
        6,773 branch-misses

In this case 3 of them are not counted and perf does not tell me why.
I'm guessing that my processor (Core2 Duo T9550) does not support the
stalled cycles counters. Should perf not emit a message telling me that?

However, cycles is supported by the processor:

perf stat -e cycles -- sleep 1

Performance counter stats for 'sleep 1':

         1,091,102 cycles

Based on that I am guessing that only the last N requested events are
counted where N is processor specific. In my case N is apparently 3 as
this works:

perf stat -e cycles -e instructions -e branches -- sleep 1

 Performance counter stats for 'sleep 1':

    1,028,331 cycles
      634,101 instructions
      130,253 branches

but adding a fourth causes the first one to roll off -- again without
any message from perf:

perf stat -e cycles -e instructions -e branches -e branch-misses -v --
sleep 1
Performance counter stats for 'sleep 1':

<not counted> cycles
      219,727 instructions
      128,071 branches
        6,625 branch-misses

Which is confusing -- cycles are not counted, yet it should be given
that it is supported.

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab1BPAmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:42:04 -0500
Received: from drutsystem.com ([80.72.38.138]:4056 "EHLO drutsystem.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847Ab1BPAmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:42:01 -0500
X-Greylist: delayed 1866 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Feb 2011 19:42:00 EST
Message-ID: <4D5B1616.8030807@ziu.info>
Date: Wed, 16 Feb 2011 01:11:02 +0100
From: Michal Soltys <soltys@ziu.info>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: question: cpu.shares and parent-children relationshp in the hierarchy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been testing how this works in practice, and I have few 
configurations I'm not sure why they behave the way they do.

All the test processes just drain cpu with an infinite loop. 
All of them are pinned to single cpu core. cgroup with just 
-o cpu is mounted, and the scenario is following (in brackets 
- assigned cpu.shares):

    root(1024)
   /          \
Y(1024)      X(4096)
            /       \
         A(8192)   B(8192)

Four test processes sit in X, Y, A and B; root is "empty"
(effectively idle processes). The one in Y expectedly gets 
20% cpu, A and B divide the cpu share equally, but - why do 
the process in X gets only ~4.75% ? Essentially:

11:36:45 PM       PID    %usr %system  %guest    %CPU   CPU  Command
11:36:50 PM     29472   20.00    0.00    0.00   20.00     1  loadme(y)
11:36:50 PM     29473    4.80    0.00    0.00    4.80     1  loadme(x)
11:36:50 PM     29474   37.60    0.00    0.00   37.60     1  loadme(a)
11:36:50 PM     29475   37.60    0.00    0.00   37.60     1  loadme(b)

In the other words - what is the intended relation between ancestor's 
cpu.shares and its children ? Looking at the example above, it looks 
like the task in X should get 4/5 (root unused, 1/5 for Y, the rest 
for X subtree) * 1/5 (from assigned values in X subtree, 
4096/20480) - but that would be ~16%.

The task in X behaves like if X had 1024 - maybe it's always assumed 
when parent-children relationship is considered, and the actual value 
is used only when dividing cpu between siblings ?

If I move the test task from X to root, the situation will change to:

11:56:49 PM       PID    %usr %system  %guest    %CPU   CPU  Command
11:56:54 PM     29472   16.60    0.00    0.00   16.60     1  loadme(y)
11:56:54 PM     29473   16.60    0.00    0.00   16.60     1  loadme(root)
11:56:54 PM     29474   33.20    0.20    0.00   33.40     1  loadme(a)
11:56:54 PM     29475   33.40    0.00    0.00   33.40     1  loadme(b)

In this scenario, everything seems as expected - 1/6 for Y, 1/6 for root, 
4/6 for X subtree.


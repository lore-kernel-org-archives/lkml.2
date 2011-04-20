Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab1DTPjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:39:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57657 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab1DTPjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:39:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PUGzNxxjTH3+km5Tw++Uf7hxj35WYkMc2pCouI8AYmcqf4bPeO4XmlONCzZMdhPPNw
         PsjFotuhYrs5SWT37DWbvB+6zKYgf0AtgmEdafahTZ40Gag0YJ9YBcahqZs5M3uA89RM
         Ahdv5oMWLuCgKdUKR3fAWZOWUc3u9SbJGCU3w=
Date: Wed, 20 Apr 2011 17:39:07 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc4 (regression: NUMA on multi-node CPUs broken)
Message-ID: <20110420153907.GA9000@alberich.amd.com>
References: <BANLkTin1=uPcyBgy9S_2TJASk8qTkeueEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin1=uPcyBgy9S_2TJASk8qTkeueEA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch breaks real NUMA on multi-node CPUs like AMD
Magny-Cours and should be reverted (or changed to just take effect in
case of numa=fake):

  commit 7d6b46707f2491a94f4bd3b4329d2d7f809e9368
  Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
  Date:   Fri Apr 15 20:39:01 2011 +0900

    x86, NUMA: Fix fakenuma boot failure

    ...

    Thus, this patch implements a reassignment of node-ids if buggy firmware
    or numa emulation makes wrong cpu node map. Tt enforce all logical cpus
    in the same physical cpu share the same node.

    ...

  +static void __cpuinit check_cpu_siblings_on_same_node(int cpu1, int cpu2)
  +{
  +       int node1 = early_cpu_to_node(cpu1);
  +       int node2 = early_cpu_to_node(cpu2);
  +
  +       /*
  +        * Our CPU scheduler assumes all logical cpus in the same physical cpu
  +        * share the same node. But, buggy ACPI or NUMA emulation might assign
  +        * them to different node. Fix it.
  +        */

   ...

This is a false assumption. Magny-Cours has two nodes in the same
physical package. The scheduler was (kind of) fixed to work around
this boot problem for multi-node CPUs (with 2.6.32). If this is also
an issue with wrong cpu node maps in case of NUMA emulation this might
be fixed similar or this quirk should only be applied in case of NUMA
emulation.

With this patch Linux shows

   root # numactl  --hardware
   available: 8 nodes (0-7)
   node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11
   node 0 size: 8189 MB
   node 0 free: 7937 MB
   node 1 cpus:
   node 1 size: 16384 MB
   node 1 free: 16129 MB
   node 2 cpus: 12 13 14 15 16 17 18 19 20 21 22 23
   node 2 size: 8192 MB
   node 2 free: 8024 MB
   node 3 cpus:
   node 3 size: 16384 MB
   node 3 free: 16129 MB
   node 4 cpus: 24 25 26 27 28 29 30 31 32 33 34 35
   node 4 size: 8192 MB
   node 4 free: 8013 MB
   node 5 cpus:
   node 5 size: 16384 MB
   node 5 free: 16129 MB
   node 6 cpus: 36 37 38 39 40 41 42 43 44 45 46 47
   node 6 size: 8192 MB
   node 6 free: 8025 MB
   node 7 cpus:
   node 7 size: 16384 MB
   node 7 free: 16128 MB
   node distances:
   node   0   1   2   3   4   5   6   7 
     0:  10  16  16  22  16  22  16  22 
     1:  16  10  22  16  16  22  22  16 
     2:  16  22  10  16  16  16  16  16 
     3:  22  16  16  10  16  16  22  22 
     4:  16  16  16  16  10  16  16  22 
     5:  22  22  16  16  16  10  22  16 
     6:  16  22  16  22  16  22  10  16 
     7:  22  16  16  22  22  16  16  10 


which is bogus. The correct NUMA-information (based on SRAT) (w/o this
patch) is

    linux # numactl --hardware
   available: 8 nodes (0-7)
   node 0 cpus: 0 1 2 3 4 5
   node 0 size: 8189 MB
   node 0 free: 7947 MB
   node 1 cpus: 6 7 8 9 10 11
   node 1 size: 16384 MB
   node 1 free: 16114 MB
   node 2 cpus: 12 13 14 15 16 17
   node 2 size: 8192 MB
   node 2 free: 7941 MB
   node 3 cpus: 18 19 20 21 22 23
   node 3 size: 16384 MB
   node 3 free: 16120 MB
   node 4 cpus: 24 25 26 27 28 29
   node 4 size: 8192 MB
   node 4 free: 8028 MB
   node 5 cpus: 30 31 32 33 34 35
   node 5 size: 16384 MB
   node 5 free: 16116 MB
   node 6 cpus: 36 37 38 39 40 41
   node 6 size: 8192 MB
   node 6 free: 8033 MB
   node 7 cpus: 42 43 44 45 46 47
   node 7 size: 16384 MB
   node 7 free: 16120 MB
   node distances:
   node   0   1   2   3   4   5   6   7 
     0:  10  16  16  22  16  22  16  22 
     1:  16  10  22  16  16  22  22  16 
     2:  16  22  10  16  16  16  16  16 
     3:  22  16  16  10  16  16  22  22 
     4:  16  16  16  16  10  16  16  22 
     5:  22  22  16  16  16  10  22  16 
     6:  16  22  16  22  16  22  10  16 
     7:  22  16  16  22  22  16  16  10 



Regards,

Andreas

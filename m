Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab1LEJdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:33:15 -0500
Received: from mx2.parallels.com ([64.131.90.16]:39041 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab1LEJdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:33:13 -0500
Message-ID: <4EDC8FB1.60407@parallels.com>
Date: Mon, 5 Dec 2011 07:32:33 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        <cgroups@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>, Linux Containers <containers@lists.osdl.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: How to draw values for /proc/stat
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Specially Peter and Paul, but all the others:

As you can see in https://lkml.org/lkml/2011/12/4/178, and in my answer 
to that, there is a question - one I've asked before but without that 
much of an audience - of whether /proc files read from process living on 
cgroups should display global or per-cgroup resources.

In the past, I was arguing for a knob to control that, but I recently 
started to believe that a knob here will only overcomplicate matters:
if you live in a cgroup, you should display only the resources you can 
possibly use. Global is for whoever is in the main cgroup.

Now, it comes two questions:
1) Do you agree with that, for files like /proc/stat ? I think the most 
important part is to be consistent inside the system, regardless of what 
is done

2) Will cpuacct stay? I think if it does, that becomes almost mandatory 
(at least the bind mount idea is pretty much over here), because drawing 
value for /proc/stat becomes quite complex.
The cpuacct cgroup can provide user, sys, etc values. But we also have:

* nr_context_switches,
* jiffies since boot,
* total_forks,
* nr_running,
* nr_iowait,

Now I doubt any of us want to see /proc/stat extended to accommodate 
things like nr_context_switches, or even worse, nr_running. The way I 
see it, there are two options here:

  a) moving everything to cpu cgroup so we keep all values being drawn
     from the same place
  b) Collect that info from multiple places in a transparent way. ctx,
     nr_running and nr_iowait will probably come from cpu. jiffies can
     come from wherever, and maybe we can even draw total_forks
     from Frederic's and avoid counting it twice.

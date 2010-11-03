Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab0KCS11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:27:27 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:58692 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab0KCS1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:27:25 -0400
Message-ID: <4CD1A986.2000508@us.ibm.com>
Date: Wed, 03 Nov 2010 13:27:18 -0500
From: Karl Rister <kmr@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: pjt@google.com
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>, Paul Turner <p@us.ibm.com>,
        habanero@us.ibm.com
Subject: Re: [RFC tg_shares_up improvements - v1 00/12] [RFC tg_shares_up
 - v1 00/12] Reducing cost of tg->shares distribution
References: <20101016044349.830426011@google.com>
In-Reply-To: <20101016044349.830426011@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All

Here is a some performance data for the previously posted patches 
running a LAMP workload in a cloud-like environment which show promising 
reductions in CPU utilization.  In this particular test, 32 groups 
equaling 64 KVM guests (each group consists of an Apache server guest 
and a MySQL server guest) are running a LAMP workload being driven by 
external load drivers.  When using the default values in /etc/cgconfig.conf:

mount {
         cpuset  = /cgroup/cpuset;
         cpu     = /cgroup/cpu;
         cpuacct = /cgroup/cpuacct;
         memory  = /cgroup/memory;
         devices = /cgroup/devices;
         freezer = /cgroup/freezer;
         net_cls = /cgroup/net_cls;
         blkio   = /cgroup/blkio;
}

which enable libvirt usage of cgroups the contents of /proc/cgroups 
looks like this before launching the guests:

#subsys_name    hierarchy       num_cgroups     enabled
cpuset  1       4       1
ns      0       1       1
cpu     2       4       1
cpuacct 3       4       1
memory  4       4       1
devices 5       4       1
freezer 6       4       1
net_cls 7       1       1
blkio   8       1       1

and like this after launching the guests:

#subsys_name    hierarchy       num_cgroups     enabled
cpuset  1       68      1
ns      0       1       1
cpu     2       68      1
cpuacct 3       68      1
memory  4       68      1
devices 5       68      1
freezer 6       68      1
net_cls 7       1       1
blkio   8       1       1

When running the workload the run with the patches used significantly 
less CPU:

Host CPU utilization with patches: 54.35%
Host CPU utilization without patches: 80.89%

Since the workload uses a fixed injection rate the achieved throughput 
for both test runs was the same, however the run with the patches 
applied did achieve better quality of service metrics.

NOTE: The runs were made using kvm.git changeset 
cec8b6b972a572b69d4902f57fb659e8a4c749af.

-- 
Karl Rister <kmr@us.ibm.com>

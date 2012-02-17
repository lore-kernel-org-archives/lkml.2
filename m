Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab2BQJIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:08:14 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:35392 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2BQJIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:08:02 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 00/14] sched: entity load-tracking re-work
In-Reply-To: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Fri, 17 Feb 2012 14:37:16 +0530
Message-ID: <87k43lde0r.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
x-cbid: 12021623-7014-0000-0000-00000096E4C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

On Wed, 01 Feb 2012 17:38:26 -0800, Paul Turner <pjt@google.com> wrote:
> Hi all,
> 
> The attached series is an RFC on implementing load tracking at the entity
> instead of cfs_rq level. This results in a bottom-up load-computation in which
> entities contribute to their parents load, as opposed to the current top-down
> where the parent averages its children.  In particular this allows us to
> correctly migrate load with their accompanying entities and provides the
> necessary inputs for intelligent load-balancing and power-management.
> 
> It was previously well tested and stable, but that was on v3.1-; there's been
> some fairly extensive changes in the wake-up path since so apologies if anything
> was broken in the rebase.Note also, since this is also an RFC on the approach I
> have not yet de-linted the various CONFIG combinations for introduced compiler
> errors.
> 

I gave a quick run to this series, and it seems the fairness across
taskgroups is broken with this.

Test setup:
Machine : IBM xSeries with Intel(R) Xeon(R) x5570 2.93GHz CPU with 8
core, 64GB RAM, 16 cpu.

Create 3 taskgroups: fair16, fair32 and fair48 having 16, 32 and 48
cpu-hog tasks respectively. They have equal shares(default 1024), so
they should consume roughly the same time.

120secs run 1:
Time consumed by fair16 cgroup:  712912 Tasks: 16
Time consumed by fair32 cgroup:  650977 Tasks: 32
Time consumed by fair48 cgroup:  575681 Tasks: 48

120secs run 2:
Time consumed by fair16 cgroup:  686295 Tasks: 16
Time consumed by fair32 cgroup:  643474 Tasks: 32
Time consumed by fair48 cgroup:  611415 Tasks: 48

600secs run 1:
Time consumed by fair16 cgroup:  4109678 Tasks: 16
Time consumed by fair32 cgroup:  1743983 Tasks: 32
Time consumed by fair48 cgroup:  3759826 Tasks: 48

600secs run 2:
Time consumed by fair16 cgroup:  3893365 Tasks: 16
Time consumed by fair32 cgroup:  3028280 Tasks: 32
Time consumed by fair48 cgroup:  2692001 Tasks: 48

As you can see there is a lot of variance in the above results.

wo patches
120secs run 1:
Time consumed by fair16 cgroup:  667644 Tasks: 16
Time consumed by fair32 cgroup:  653771 Tasks: 32
Time consumed by fair48 cgroup:  624915 Tasks: 48

600secs run 1:
Time consumed by fair16 cgroup:  3278425 Tasks: 16
Time consumed by fair32 cgroup:  3140335 Tasks: 32
Time consumed by fair48 cgroup:  3198817 Tasks: 48

Regards
Nikunj


--=-=-=
Content-Type: application/x-sh
Content-Disposition: attachment; filename=fair.sh
Content-Transfer-Encoding: base64
Content-Description: Fairness Script

IyEgL2Jpbi9iYXNoCgpXT1JLRElSPWBwd2RgCkNHRElSPS9jZ3JvdXAvY3B1ClRBU0tTTElTVD0i
MTYgMzIgNDgiClRJTUVUT1JVTj02MAoKaWYgWyAkMSA+IDAgXQp0aGVuCiAgICBUSU1FVE9SVU49
JDE7CmZpCgpjZCAkQ0dESVIKZm9yIGkgaW4gYGVjaG8gJFRBU0tTTElTVGAKZG8KICAgIGVjaG8g
LW5lICJTdGFydGluZyB0YXNrIGdyb3VwIGZhaXIkaS4uLiIKICAgIG1rZGlyIC1wIGZhaXIkaQog
ICAgCiAgICBmb3IgaiBpbiBgc2VxIDEgJGlgCiAgICBkbwoJJFdPUktESVIvZG93aGlsZSAmCgll
Y2hvICQhID4gZmFpciRpL3Rhc2tzCiAgICBkb25lCiAgICBlY2hvICJkb25lIgpkb25lCgpjZCAk
V09SS0RJUgplY2hvICJXYWl0aW5nIGZvciB0aGUgdGFzayB0byBydW4gZm9yICRUSU1FVE9SVU4g
c2VjcyIKCnNsZWVwICRUSU1FVE9SVU4KCmVjaG8gIkludGVycHJldGluZyB0aGUgcmVzdWx0cy4g
UGxlYXNlIHdhaXQuLi4uIgpjYXQgL3Byb2Mvc2NoZWRfZGVidWcgfCBncmVwICJkb3doaWxlIiA+
IGZhaXJ0ZXN0LmxvZwpmb3IgaSBpbiBgZWNobyAkVEFTS1NMSVNUYApkbwplY2hvIC1uZSAgIlRp
bWUgY29uc3VtZWQgYnkgZmFpciRpIGNncm91cDogICIKRkFJUlJFU1VMVD1gc2VkIC1uZSAiL2Zh
aXIkaVwkL3AiIGZhaXJ0ZXN0LmxvZyB8IGdhd2sgJyQxID09ICJkb3doaWxlIiB7IHN1bSArPSAk
NyB9ICQxID09IlIiIHsgc3VtICs9ICQ4fSBFTkQgeyBwcmludGYgIiUyMGQgVGFza3M6ICVkXG4i
LCBzdW0sTlIgfSdgCmVjaG8gJEZBSVJSRVNVTFQKZG9uZQoKa2lsbGFsbCBkb3doaWxlCg==
--=-=-=--


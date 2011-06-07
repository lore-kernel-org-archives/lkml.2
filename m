Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab1FGM4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:56:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64163 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab1FGM4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:56:07 -0400
Message-ID: <4DEE205E.8000601@cn.fujitsu.com>
Date: Tue, 07 Jun 2011 20:58:06 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 0/15] KVM: optimize for MMIO handled
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 20:55:48,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 20:55:48,
	Serialize complete at 2011-06-07 20:55:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea of this patchset is from Avi:
| We could cache the result of a miss in an spte by using a reserved bit, and
| checking the page fault error code (or seeing if we get an ept violation or
| ept misconfiguration), so if we get repeated mmio on a page, we don't need to
| search the slot list/tree.
| (https://lkml.org/lkml/2011/2/22/221)

The aim of this patchset is to support fast mmio emulate, it reduce searching
mmio gfn from memslots which is very expensive since we need to walk all slots
for mmio gfn, and the other advantage is: we can reduce guest page table walking
for soft mmu.

Lockless walk shadow page table is introduced in this patchset, it is the light
way to check the page fault is the real mmio page fault or something is running
out of our mind.

And, if shadow_notrap_nonpresent_pte is enabled(bypass_guest_pf=1), mmio page
fault and normal page fault is mixed(the reserved is set for all page fault),
it has little regression, if the box can generate lots of mmio access, for
example, the network server, it can disable shadow_notrap_nonpresent_pte and
enable mmio pf, after all, we can enable/disable mmio pf at the runtime.

The performance test result:

Netperf (TCP_RR):
===========================
ept is enabled:

      Before         After
1st   709.58         734.60
2nd   715.40         723.75
3rd   713.45         724.22

ept=0 bypass_guest_pf=0:

      Before         After
1st   706.10         709.63
2nd   709.38         715.80
3rd   695.90         710.70

Kernbech (do not redirect output to /dev/null)
==========================
ept is enabled:

      Before         After
1st   2m34.749s      2m33.482s
2nd   2m34.651s      2m33.161s
3rd   2m34.543s      2m34.271s

ept=0 bypass_guest_pf=0:

      Before         After
1st   4m43.467s      4m41.873s
2nd   4m45.225s      4m41.668s
3rd   4m47.029s      4m40.128s


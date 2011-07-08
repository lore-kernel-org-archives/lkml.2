Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab1GHJU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 05:20:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60873 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1GHJU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 05:20:56 -0400
Subject: Re: jump_label defaults (was Re: [patch 00/17] CFS Bandwidth
 Control v7.1)
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@openvz.org>, Hu Tao <hutao@cn.fujitsu.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <1310070974.3282.678.camel@twins>
References: <20110707053036.173186930@google.com>
	 <20110707112302.GB8227@elte.hu> <1310049528.3282.583.camel@twins>
	 <20110707145159.GD19193@elte.hu> <1310050482.3282.584.camel@twins>
	 <20110707145620.GF19193@elte.hu> <20110707162344.GB2536@redhat.com>
	 <1310059220.3282.591.camel@twins>  <20110707181535.GD2536@redhat.com>
	 <1310070974.3282.678.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 08 Jul 2011 11:20:32 +0200
Message-ID: <1310116832.3282.699.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 22:36 +0200, Peter Zijlstra wrote:
> Hrm,. I can't seem to make that work, damn CPP for not being
> recursive.

Ha! the wonders of sleep, ok I can make this part work.

So how do we write this static_branch_true() thing?

But then I realized that if we do something like:

static __always_inline bool arch_static_branch(struct jump_label_key *key)
{
        asm goto("1:"
                JUMP_LABEL_INITIAL_NOP
                ".pushsection __jump_table,  \"aw\" \n\t"
                _ASM_ALIGN "\n\t"
                _ASM_PTR "1b, %l[l_yes], %c0 \n\t"
                ".popsection \n\t"
                : :  "i" (key) : : l_yes);
        return false;
l_yes:
        return true;
}

Simply flipping the true and false in there isn't going to work, because
then its similar to !static_branch() and jump_label_inc() is going to
disable it.

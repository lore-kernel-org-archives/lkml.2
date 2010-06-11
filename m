Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760493Ab0FKTkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 15:40:20 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50618 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760446Ab0FKTkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 15:40:19 -0400
Date: Fri, 11 Jun 2010 15:40:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: sequence lock in Linux
Message-ID: <20100611194016.GA5213@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:34:56 up 139 days, 22:12,  7 users,  load average: 0.17, 0.19,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

(CCing lkml)

Is it just me, or the following code:

static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
{
        unsigned ret;

repeat:
        ret = sl->sequence;
        smp_rmb();
        if (unlikely(ret & 1)) {
                cpu_relax();
                goto repeat;
        }

        return ret;
}

could use a ACCESS_ONCE() around the sl->sequence read ? I'm concerned about the
compiler generating code that reads the sequence number chunkwise.

The same apply to all other reads of the sequence number in seqlock.h (including
the retry code).

Thoughts ?

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

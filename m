Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab1BITyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 14:54:11 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38541 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab1BITyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 14:54:10 -0500
Subject: [PATCH 0/5] fix up /proc/$pid/smaps to not split huge pages
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 09 Feb 2011 11:54:06 -0800
Message-Id: <20110209195406.B9F23C9F@kernel>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea, after playing with this for a week or two, I'm quite a bit
more confident that it's not causing much harm.  Seems a fairly
low-risk feature.  Could we stick these somewhere so they'll at
least hit linux-next for the 2.6.40 cycle perhaps?

--

I'm working on some more reports that transparent huge pages and
KSM do not play nicely together.  Basically, whenever THP's are
present along with KSM, there is a lot of attrition over time,
and we do not see much overall progress keeping THP's around:

	http://sr71.net/~dave/ibm/038_System_Anonymous_Pages.png

(That's Karl Rister's graph, thanks Karl!)

However, I realized that we do not currently have a nice way to
find out where individual THP's might be on the system.  We
have an overall count, but no way of telling which processes or
VMAs they might be in.

I started to implement this in the /proc/$pid/smaps code, but
quickly realized that the lib/pagewalk.c code unconditionally
splits THPs up.  This set reworks that code a bit and, in the
end, gives you a per-map count of the numbers of huge pages.
It also makes it possible for page walks to _not_ split THPs.


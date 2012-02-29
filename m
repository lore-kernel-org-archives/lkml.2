Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab2B2UbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:31:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab2B2UbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:31:21 -0500
Date: Wed, 29 Feb 2012 12:31:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
Message-Id: <20120229123120.127e21fd.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1202281329190.25590@router.home>
References: <20120223180740.C4EC4156@kernel>
	<alpine.DEB.2.00.1202231240590.9878@router.home>
	<4F468F09.5050200@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1202231334290.10914@router.home>
	<4F469BC7.50705@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1202231536240.13554@router.home>
	<m1ehtkapn9.fsf@fess.ebiederm.org>
	<alpine.DEB.2.00.1202240859340.2621@router.home>
	<4F47BF56.6010602@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1202241053220.3726@router.home>
	<alpine.DEB.2.00.1202241105280.3726@router.home>
	<4F47C800.4090903@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1202241131400.3726@router.home>
	<87sjhzun47.fsf@xmission.com>
	<alpine.DEB.2.00.1202271238450.32410@router.home>
	<87d390janv.fsf@xmission.com>
	<alpine.DEB.2.00.1202271636230.6435@router.home>
	<alpine.DEB.2.00.1202281329190.25590@router.home>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 13:30:19 -0600 (CST)
Christoph Lameter <cl@linux.com> wrote:

> Migration functions perform the rcu_read_unlock too early. As a result the
> task pointed to may change from under us.
> 
> The following patch extend the period of the rcu_read_lock until after the
> permissions checks are done. We also take a refcount so that the task
> reference is stable when calling security check functions and performing
> cpuset node validation (which takes a mutex).
> 
> The refcount is dropped before actual page migration occurs so there is no
> change to the refcounts held during page migration.
> 
> Also move the determination of the mm of the task struct to immediately
> before the do_migrate*() calls so that it is clear that we switch from
> handling the task during permission checks to the mm for the actual
> migration. Since the determination is only done once and we then no longer
> use the task_struct we can be sure that we operate on a specific address
> space that will not change from under us.

What was the user-visible impact of the bug?

Please always include info this in bug fix changelogs - it helps me and
others to decide which kernel version(s) the patch should be merged
into.


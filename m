Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab0FTSVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 14:21:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145Ab0FTSVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 14:21:45 -0400
Date: Sun, 20 Jun 2010 20:19:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 2/6] pidns: Call pid_ns_prepare_proc from
	create_pid_namespace
Message-ID: <20100620181956.GA3258@redhat.com>
References: <20100617212003.GA4182@redhat.com> <20100618082033.GD16877@hawkmoon.kerlabs.com> <20100618111554.GA3252@redhat.com> <20100618160849.GA7404@redhat.com> <20100618173320.GG16877@hawkmoon.kerlabs.com> <20100618175541.GA13680@redhat.com> <20100618212355.GA29478@redhat.com> <20100619190840.GA3424@redhat.com> <m1pqzmqema.fsf_-_@fess.ebiederm.org> <m1hbkyqeib.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hbkyqeib.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20, Eric W. Biederman wrote:
>
> Reorganize proc_get_sb so it can be called before the struct pid
> of the first process is allocated.

This is what

	[PATCH 1/4] procfs: proc_get_sb: consolidate/cleanup root_inode->pid logic
	[PATCH 2/4] procfs: kill the global proc_mnt variable

do. But,

> @@ -96,6 +97,9 @@ static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_p
>  	for (i = 1; i < PIDMAP_ENTRIES; i++)
>  		atomic_set(&ns->pidmap[i].nr_free, BITS_PER_PAGE);
>
> +	if (pid_ns_prepare_proc(ns))
> +		goto out_free_map;
> +
>  	return ns;

Afaics, this is wrong.

If pid_ns_prepare_proc() fails we shouldn't blindly return ENOMEM
and, more importantly, we need put_pid_ns(parent_ns).

Oleg.


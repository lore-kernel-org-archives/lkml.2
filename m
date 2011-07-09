Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab1GIJOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 05:14:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab1GIJOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 05:14:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1310194141-18700-1-git-send-email-edwin@cheatah.nl>
References: <1310194141-18700-1-git-send-email-edwin@cheatah.nl>
To: Edwin van Vliet <edwin@cheatah.nl>
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/cred: Fix bug on cred reference count
Date: Sat, 09 Jul 2011 10:13:47 +0100
Message-ID: <10155.1310202827@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Edwin van Vliet <edwin@cheatah.nl> wrote:

> The comment above states that the old obj ref and subj ref should BOTH be
> released. However, the line is repeated so the old obj ref is released twice
> yet the subj ref is not. So either the comment is wrong, or this is simpy a
> bug. Releasing the same ref twice seems wrong in any case.

The comment is correct and the double release is correct.

task_struct has *two* refs to the cred being replaced and both need to be
updated:

	current->real_cred	- The objective cred
	current->cred		- The subjective cred

The subjective cred is the one used by a task to access other objects; the
objective cred details how the task is perceived by the outside world and
affects how other tasks act upon it.

Normally a task's two cred pointers point to the same cred, but under some
circumstances (such as in cachefiles), the subjective cred can be overridden.

David

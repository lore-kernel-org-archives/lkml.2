Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab2GWSR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:17:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab2GWSRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:17:52 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] dlm patches for 3.6
Date: Mon, 23 Jul 2012 13:17:41 -0500
Message-Id: <1343067467-24308-1-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These are the dlm patches from -next for 3.6.  The first is a major
internal redesign of the way master nodes are recorded.  The old dirtbl
hash table, which just recorded the master node of a resource, has been
removed.  The rsbtbl hash table has always duplicated the master value
from dirtbl, but is now the only record of the master node.

Having two full hash tables of all resources has always been inefficient,
especially since one just duplicated information from the other.  Requests
that are all local will require one instead of two lengthy hash table
searches.

The other substantial patch is made possible by the dirtbl removal, and
fixes a long standing race between resource removal and lookup by
reworking how removal is done.  At the same time it improves the shrink
function efficiency by avoiding repeated searches through hash buckets.

David Teigland (6):
      dlm: use rsbtbl as resource directory
      dlm: use idr instead of list for recovered rsbs
      dlm: fix race between remove and lookup
      dlm: use wait_event_timeout
      dlm: fix conversion deadlock from recovery
      dlm: fix missing dir remove

 fs/dlm/config.c       |    7 -
 fs/dlm/config.h       |    1 -
 fs/dlm/debug_fs.c     |  103 +++-
 fs/dlm/dir.c          |  287 +++--------
 fs/dlm/dir.h          |    7 +-
 fs/dlm/dlm_internal.h |   62 ++-
 fs/dlm/lock.c         | 1292 ++++++++++++++++++++++++++++++++++++++++---------
 fs/dlm/lock.h         |    5 +-
 fs/dlm/lockspace.c    |   45 +-
 fs/dlm/rcom.c         |  147 ++++--
 fs/dlm/rcom.h         |    1 +
 fs/dlm/recover.c      |  295 +++++++----
 fs/dlm/recover.h      |    2 +-
 fs/dlm/recoverd.c     |   14 +-
 14 files changed, 1600 insertions(+), 668 deletions(-)

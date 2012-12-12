Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2LLSkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:40:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42850 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab2LLSku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:40:50 -0500
Date: Wed, 12 Dec 2012 18:40:49 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwysocha@redhat.com
Subject: Re: [PATCH] vfs: remove unneeded permission check from path_init
Message-ID: <20121212184049.GO4939@ZenIV.linux.org.uk>
References: <1355234176-767-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355234176-767-1-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 08:56:16AM -0500, Jeff Layton wrote:
> When path_init is called with a valid dfd, that code checks permissions
> on the open directory fd and returns an error if the check fails. This
> permission check is redundant, however.
> 
> Both callers of path_init immediately call link_path_walk afterward. The
> first thing that link_path_walk does is to check for exec permissions
> at the starting point of the path walk.
> 
> In most cases, these checks are very quick, but when the dfd is for a
> file on a NFS mount with the actimeo=0, each permission check goes
> out onto the wire. The result is 2 identical ACCESS calls.
> 
> Given that these codepaths are fairly "hot", I think it makes sense to
> eliminate the permission check in path_init and simply assume that the
> caller will eventually check the permissions before proceeding.

Applied, with one modification to commit message - the second paragraph
replaced with

Both callers of path_init immediately call link_path_walk afterward. The
first thing that link_path_walk does for pathnames that do not consist
only of slashes is to check for exec permissions at the starting point of
the path walk.  And this check in path_init() is on the path taken only
when *name != '/' && *name != '\0'.

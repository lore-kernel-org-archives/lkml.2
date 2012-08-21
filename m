Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab2HUKGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:06:37 -0400
Received: from seven.medozas.de ([5.9.24.206]:57037 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab2HUKGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:06:34 -0400
Date: Tue, 21 Aug 2012 12:06:33 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
cc: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk, tytso@mit.edu,
        Anatol Pomazau <anatol@google.com>
Subject: Re: [PATCH] fs: Preserve error code in get_empty_filp()
In-Reply-To: <1343845147-21394-1-git-send-email-anatol.pomozov@gmail.com>
Message-ID: <alpine.LNX.2.01.1208211204420.1100@frira.zrqbmnf.qr>
References: <1343845147-21394-1-git-send-email-anatol.pomozov@gmail.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2012-08-01 20:19, anatol.pomozov@gmail.com wrote:
>Allocating a file structure in function get_empty_filp() might fail because
>of several reasons:
> - not enough memory for file structures
> - operation is not allowed
> - user is over its limit
>
>Currently the function returns NULL in all cases and we loose the exact
>reason of the error. All callers of get_empty_filp() assume that the function
>can fail with ENFILE only.
>
>Return error through pointer. Change all callers to preserve this error code.

> 	percpu_counter_inc(&nr_files);
> 	f->f_cred = get_cred(cred);
>-	if (security_file_alloc(f))
>+	if (security_file_alloc(f)) {
>+		error = -EPERM;
> 		goto fail_sec;
>+	}

You are not preserving the error code from security_file_alloc here.

In particular, apparmoar/lsm.c: file_alloc_security can return -ENOMEM,
for example.

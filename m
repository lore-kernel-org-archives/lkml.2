Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab0ERGbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:31:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999Ab0ERGa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:30:59 -0400
Date: Tue, 18 May 2010 12:02:41 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Steven Liu <lingjiujianke@gmail.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] fix a code style in drivers/char/virtio_console.c
Message-ID: <20100518063241.GB27262@amit-laptop.redhat.com>
References: <AANLkTilW8zZxCOrdiefZ4ZtixprI58LzDZ6Cz03z4lFk@mail.gmail.com>
 <20100518052230.GA1706@amit-laptop.redhat.com>
 <AANLkTimXLkzb-CyhbkOaubAOiSsIkGKW0y5Cblrwfvst@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimXLkzb-CyhbkOaubAOiSsIkGKW0y5Cblrwfvst@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On (Tue) May 18 2010 [13:41:29], Steven Liu wrote:
> Hi, Amit,
> 
>     if 'err' initialised in this path, it needn't do err = -ENOMEM
> after,isn't it?

What I mean is if we later add some code that just does:

	if (err)
		goto fail;

then 'ret' can be -ENOMEM, as it was initialised to, which would be
fine. But if a later patch adds something like:

+	ret = -EIO;
+	err = ...
+	if (err)
+		goto fail;
+
	err = ...
	if (err)
		goto fail;

In this case, the 2nd if() would now return EIO instead of ENOMEM as
earlier.

Also, this style of coding can prevent uninitialised usage of 'ret', eg:


	int ret;

	if (err)
		goto fail;

fail:
	return ret;

In this case, the compiler will warn about 'ret' being used
uninitialised.

This is just a coding style issue. I had initially coded it the way your
patch does, but Rusty asked me to change that and I like this new style
better: there's less scope for surprises.

		Amit

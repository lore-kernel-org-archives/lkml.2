Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab2K3LDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:03:48 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:58990 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2K3LDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:03:46 -0500
MIME-Version: 1.0
In-Reply-To: <20121130001304.GB2590@local>
References: <1354210800-27230-1-git-send-email-dinggnu@gmail.com>
	<20121130001304.GB2590@local>
Date: Fri, 30 Nov 2012 12:03:45 +0100
X-Google-Sender-Auth: 2yTlGCizJhtuspFfUz1OuXB5swI
Message-ID: <CAM3j68q7LPJM1aUZbwHJkyive3UcRYwg-yF-O=UXmfsi98E6dA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] uio.c: solve memory leak
From: Cong Ding <dinggnu@gmail.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans, I think the memory allocated with kzalloc is properly freed
by calling kobject_put.

I can give a simple explanation.

1)  when we call kobject_init, the parameter portio_attr_type is
passed in. portio_attr_type includes a function pointer to
portio_release, which releases the memory of portio.

2) when we call kobject_put, kref_put is called with the pointer of
function kobject_release.
3) kref_put calls kref_sub, with the same pointer of function kobject_release.
4) and kref_put calls the function kboject_release if
atomic_sub_and_test returns true

5) let's look at what kobject_release is. it calls kobject_cleanup,
and kobject_cleanup calls t->release(kobj) where t->release is exactly
the function we passed in through portio_init at step (1). so function
portio_release is called, and the memory allocated with kzalloc is
freed.

If there are anything wrong in my analysis, please feel free to let me know.

Personally, I suggest to add a function to create and release
uio_portio, which is similar as kobject_create and kobject_put in file
lib/kobject.c. In this way, it avoid other readers thinking the memory
is not freed (and we should add some comments here). For example,
uio_portio_create call kzalloc and kboject_init, and returns
uio_portio, which is similar as function kobject_create; and
uio_portio_release calls kobject_put to release the memory. And we do
same thing for uio_map.

The usage here is quite strange, but it works. If I write this
function from zero, I will use a pointer to kobject in uio_portio
struct instead of kobject struct itself. In this case I can call
kobject_create instead of kobject_init, and then we do both
kzalloc(uio_portio) and kfree(uio_portio) in the file uio.c.

Best,
Cong

On Fri, Nov 30, 2012 at 1:13 AM, Hans J. Koch <hjk@hansjkoch.de> wrote:
> There's still another bug: The memory allocated with kzalloc is
> never freed.

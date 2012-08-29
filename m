Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2H2QCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 12:02:49 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55307 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2H2QCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 12:02:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120829101423.GA18856@ram-ThinkPad-T61>
References: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
	<1340736849-14875-3-git-send-email-yinghai@kernel.org>
	<CAE9FiQVrUbEzopKfeoQZFNdNszLN96brC+rYuGXQCfZvpi_ETQ@mail.gmail.com>
	<CAE9FiQUXTngUZp2c2dLVRZjFxhXD9e+XYW6Pn0zaHvMt0fB+eA@mail.gmail.com>
	<CA+55aFxLUExCZE1=gQpDT0ip9s+iMRYEVK2QjdCGNk9iympfYA@mail.gmail.com>
	<CA+55aFyb-g77CQNoR72J0pjw76ZCy_nufP=VavT_X3xBg6=G-Q@mail.gmail.com>
	<20120829101423.GA18856@ram-ThinkPad-T61>
Date: Wed, 29 Aug 2012 09:02:44 -0700
X-Google-Sender-Auth: XVRaEMvgI8bTBb5VcvsvMsfvz-c
Message-ID: <CAE9FiQVtxMWEheQAWkvHZzFRUtyEL914EFZAJjg98p6Jsq3zpw@mail.gmail.com>
Subject: Re: [PATCH -v12 02/15] resources: Add probe_resource()
From: Yinghai Lu <yinghai@kernel.org>
To: Ram Pai <linuxram@us.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 3:14 AM, Ram Pai <linuxram@us.ibm.com> wrote:
> @@ -718,12 +727,12 @@ void insert_resource_expand_to_fit(struct resource *root, struct resource *new)
>   */
>  int adjust_resource(struct resource *res, resource_size_t start, resource_size_t size)
>  {
> -       struct resource *tmp, *parent = res->parent;
> +       struct resource *tmp, *parent;
>         resource_size_t end = start + size - 1;
>         int result = -EBUSY;
>
>         write_lock(&resource_lock);
> -
> +       parent = res->parent;
>         if (!parent)
>                 goto skip;

yes, in the v7 of probe_resource() patch that  I sent before,
introduced _adjust_resource solved the problem.


@@ -741,14 +741,13 @@ void insert_resource_expand_to_fit(struc
  * arguments.  Returns 0 on success, -EBUSY if it can't fit.
  * Existing children of the resource are assumed to be immutable.
  */
-int adjust_resource(struct resource *res, resource_size_t start,
resource_size_t size)
+static int __adjust_resource(struct resource *res, resource_size_t start,
+                            resource_size_t size)
 {
        struct resource *tmp, *parent = res->parent;
        resource_size_t end = start + size - 1;
        int result = -EBUSY;

-       write_lock(&resource_lock);
-
        if (!parent)
                goto skip;

@@ -776,9 +775,19 @@ skip:
        result = 0;

  out:
-       write_unlock(&resource_lock);
        return result;
 }
+int adjust_resource(struct resource *res, resource_size_t start,
+                   resource_size_t size)
+{
+       int ret;
+
+       write_lock(&resource_lock);
+       ret = __adjust_resource(res, start, size);
+       write_unlock(&resource_lock);
+
+       return ret;
+}
 EXPORT_SYMBOL(adjust_resource);

 static void __init __reserve_region_with_split(struct resource *root,

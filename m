Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab2HaAlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 20:41:12 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38125 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2HaAlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 20:41:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQV_yjGizLWAF6FCW03g5jxOx2D_+LXMVZc1H3K1_u2dqw@mail.gmail.com>
References: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
 <1340736849-14875-3-git-send-email-yinghai@kernel.org> <CAE9FiQVrUbEzopKfeoQZFNdNszLN96brC+rYuGXQCfZvpi_ETQ@mail.gmail.com>
 <CAE9FiQUXTngUZp2c2dLVRZjFxhXD9e+XYW6Pn0zaHvMt0fB+eA@mail.gmail.com>
 <CA+55aFxLUExCZE1=gQpDT0ip9s+iMRYEVK2QjdCGNk9iympfYA@mail.gmail.com>
 <CA+55aFyb-g77CQNoR72J0pjw76ZCy_nufP=VavT_X3xBg6=G-Q@mail.gmail.com>
 <CAE9FiQUKxO5QmuaK5V1-rWzS98aRmyfDgC0Aonk-L5JRG1cd6A@mail.gmail.com> <CAE9FiQV_yjGizLWAF6FCW03g5jxOx2D_+LXMVZc1H3K1_u2dqw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 30 Aug 2012 17:40:48 -0700
Message-ID: <CAErSpo51XRqDYLZCgCmUq5jnVNgf64dAtLqW3kgGWkFHNrNJSA@mail.gmail.com>
Subject: Re: [PATCH -v12 02/15] resources: Add probe_resource()
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 10:36 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, Aug 29, 2012 at 8:57 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> also have another version for probe_resource, please check attached version -v8.
>>
>
> sorry, v8 forget removing two lines.
>
> please -v9 instead.
>
> -v8: Linus said: allocation/return is not right, and -1 step tricks make it
>         not work as generic resource probe.
>      So try to remove the needed_size tricks, and also use __adjust_resource
>         for probing instead.
> -v9: remove two lines that is supposed to be removed after converting to use
>         __adjust_resource

These tweaks might be slight improvements, but they completely miss
the point of my objection.  I just don't think the probe_resource()
interface is a reasonable addition to kernel/resource.c.  I think it's
too hard to describe what it does, and it seems like it's too specific
to what PCI needs in this particular case.  We should be able to look
at the prototype and get a pretty good idea of what the function does,
but I can't do that with this:

+int probe_resource(struct resource *b_res,
+			 struct resource *busn_res,
+			 resource_size_t needed_size, struct resource **p,
+			 int skip_nr, int limit, int stop_flags)

We already have adjust_resource(), which grows or shrinks a resource
while maintaining the invariants that the adjusted resource (1)
doesn't overlap any of its siblings and (2) still contains all its
children.

adjust_resource() seems like a fairly generic, generally useful
interface.  What you're trying to do with probe_resource() is quite
similar, except that probe_resource() adds the idea of walking up the
tree.

I think you should consider something like an "expand_resource()" that
just balloons a resource at both ends until it abuts its siblings,
i.e., it grows the resource as much as possible.  Then you know the
largest possible size, and you can use adjust_resource() to shrink it
again if you don't need that much.  You can walk up the tree in the
caller when you need to.

Bjorn

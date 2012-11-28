Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab2K1UA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:00:26 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35415 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158Ab2K1UAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:00:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-acpi@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Zdenek Kabelac <zkabelac@redhat.com>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Acpi deadlocks with 3.7.0-rc4
Date: Wed, 28 Nov 2012 21:05:06 +0100
Message-ID: <1974317.cTtd2LquyD@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CA+55aFz2p2_WUkhThjSDWAFVda6nujxX2YE_Qkqv1OVDChUEJQ@mail.gmail.com>
References: <50A513A8.9010404@redhat.com> <50B64996.1010709@redhat.com> <CA+55aFz2p2_WUkhThjSDWAFVda6nujxX2YE_Qkqv1OVDChUEJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 28, 2012 11:07:32 AM Linus Torvalds wrote:
> On Wed, Nov 28, 2012 at 9:27 AM, Zdenek Kabelac <zkabelac@redhat.com> wrote:
> >
> > I've attached bigger disasfun script output to BZ 51071.
> > https://bugzilla.kernel.org/show_bug.cgi?id=51071#c1
> >
> >
> >         if (ACPI_GET_DESCRIPTOR_TYPE(prefix_node) !=
> > 00000000000000a1 <acpi_ns_lookup+0xa1> cmpb   $0xf,0x8(%rbx)
> > 00000000000000a5 <acpi_ns_lookup+0xa5> je   0da  <acpi_ns_lookup+0xda>
> >
> > seems to be going out of bounds.
> 
> The whole "prefix_node" pointer is bogus. It seems to have the value 0x1000.
> 
> I wonder how that happened. It's loaded from 'scope_info->scope.node',
> and it *should* be a valid pointer.

Well, suppose that pnpacpi_build_resource_template() passes a handle that's
not a valid pointer to acpi_walk_resources().  What happens then is that
it is passed directly to acpi_rs_get_method_data() and from there to
acpi_ut_evaluate_object() - without validation (acpi_rs_get_method_data()
even has a comment about the parameters validity guaranteed by the caller,
heh, heh).  Then it becomes the prefix_node and is written into
info->prefix_node.  acpi_ns_evaluate() takes that and passes it to
acpi_ns_get_node() along with info->pathname that is just the name of the
method to evaluate, which is a valid string, so the "if (!pathname)" block in
acpi_ns_get_node() is not executed and we get scope_info.scope.node = prefix_node,
which is our bad pointer.  A pointer to that scope_info is passed to
acpi_ns_lookup() and we get the above.

So the code in pnpacpi_build_resource_template() is at fault by passing a
wrong pointer to acpi_walk_resources().  And the pointer is wrong probably
because the struct acpi_device pointed to by dev->data in there has been
removed during a previous suspend or resume (I'm not sure which one does
that), but the PNP layer has no idea about that.  And that bug has been there
for quite a while (like forever?).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

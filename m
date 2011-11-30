Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab1K3HCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 02:02:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab1K3HCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 02:02:51 -0500
Date: Wed, 30 Nov 2011 09:04:17 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH-RFC 1/2] tile: don't panic on iomap
Message-ID: <20111130070417.GA17781@redhat.com>
References: <cover.1322592494.git.mst@redhat.com>
 <a3bc9cb56040258dabc7b466ea217f4515b68b7d.1322592495.git.mst@redhat.com>
 <CAErSpo4N8drqe5bHVjzXy_h0HTC8Reye4+8viN4c6TtmwFheXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo4N8drqe5bHVjzXy_h0HTC8Reye4+8viN4c6TtmwFheXA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 01:04:12PM -0800, Bjorn Helgaas wrote:
> On Tue, Nov 29, 2011 at 10:54 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > I think panic on iomap is there just for debugging.
> > If we return NULL instead, the generic pci_iomap will
> > DTRT so we don't need to roll our own.
> 
> Just to be explicit about what "doing the right thing" means, here's
> what I think is changing (I think the new behavior is OK, but it *is*
> different):

I think the change is that anyone calling ioport_map *directly*
will fail. pci_iomap callers are mostly unaffected.

> 
> Old behavior: Caller calls pci_iomap(), which panics in ioport_map().

Not really, the old pci_iomap simply returned NULL in this case, it
did not call ioport_map.

> New behavior: Caller calls pci_iomap(), ioport_map() returns NULL,
> pci_iomap() returns NULL (failure), caller may check for failure.  If
> caller does not check for failure and passes the NULL to
> ioread()/iowrite(), we WARN in bad_io_access().
> 
> >  static inline void __iomem *ioport_map(unsigned long port, unsigned int len)
> >  {
> > -       return (void __iomem *) ioport_panic();
> > +       pr_info("Trying to map an IO resource - it does not exit on tile.\n");
> > +       return NULL;
> 
> s/exit/exist/
> 
> Since we only expect to see this message during debugging, maybe it
> could be more informative, e.g., use dump_stack() to identify the
> offending driver?  I don't think either the "Trying to map" message or
> the "Bad IO access" message is enough to actually make progress in
> debugging.
> 
> Bjorn

As explained above, only direct callers of ioport_map get a changed
behaviour. If we start dumping stack there we will hurt users of
pci_iomap which used to get a graceful failure and will start getting
scary messages. Is does not seem to be worth doing to simplify debugging, right?
How about sticking the function name in the pr_info message?
A simple grep for ioport_map will then get you the culprit ...
Like this:
+       pr_info("ioport_map: mapping IO resources is unsupported on tile.\n");
?

-- 
MST

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832Ab2CWQpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 12:45:33 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:41142
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753078Ab2CWQpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 12:45:31 -0400
Date: Fri, 23 Mar 2012 17:45:30 +0100 (CET)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch] Move CRC computation to separate function
In-Reply-To: <1332511796.18717.72.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1203231739330.22944@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>   <alpine.DEB.2.00.1202202112220.21022@eristoteles.iwoars.net>  <1330531826.3545.128.camel@sauron.fi.intel.com>  <alpine.DEB.2.00.1203191635030.22256@eristoteles.iwoars.net>
 <1332511796.18717.72.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When GCing a data node, it may be reencrypted as a means of organizing the
KSA and reducing the number of LEBs that need to be erased. A Long term
keys in one half for stable data, short term in the other.  During this
reencryption the CRC is recomputed. Also, after truncating it the last
chunk needs to be reencrypted too, or else the key can be used with the
old version to find the truncated part.

For the misc.h approach, it does not currently include ubifs-media.h, but
that is where UBIFS_CRC32_INIT is defined, so move it also to misc.h



On Fri, 23 Mar 2012, Artem Bityutskiy wrote:

> On Mon, 2012-03-19 at 23:46 +0100, Joel Reardon wrote:
> >  /**
> > + * ubifs_set_datanode_crc - writes the crc for a data node to the common
> > + * header.
> > + * @node: the data node
> > + */
> > +void ubifs_set_datanode_crc(void *node)
> > +{
> > +	struct ubifs_ch *ch = (struct ubifs_ch *) node;
> > +	int len = le32_to_cpu(ch->len);
> > +	ch->crc = cpu_to_le32(crc32(UBIFS_CRC32_INIT, node + 8, len - 8));
> > +}
>
> Will this be used by other code, outside of io.c? Because currently
> there is only one user in the same file, which does not justify
> introducing it and making non-static. If answers are "yes", then it is
> better to make it static inline and put to misc.h instead, because it is
> very small.
>
> >  void ubifs_prepare_node(struct ubifs_info *c, void *node, int len, int pad)
> >  {
> > -	uint32_t crc;
> >  	struct ubifs_ch *ch = node;
> >  	unsigned long long sqnum = next_sqnum(c);
> >
> > @@ -390,8 +401,7 @@ void ubifs_prepare_node(struct ubifs_info *c, void *node, int len, int pad)
> >  	ch->group_type = UBIFS_NO_NODE_GROUP;
> >  	ch->sqnum = cpu_to_le64(sqnum);
> >  	ch->padding[0] = ch->padding[1] = 0;
> > -	crc = crc32(UBIFS_CRC32_INIT, node + 8, len - 8);
> > -	ch->crc = cpu_to_le32(crc);
> > +	ubifs_set_datanode_crc(node);
>
> But ubifs_prepare_node() is generic and works for any node type, not
> just data nodes, which means that using 'datanode' in the name is not a
> good idea.
>
> --
> Best Regards,
> Artem Bityutskiy
>

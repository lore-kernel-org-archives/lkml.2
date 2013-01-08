Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab3AHW5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:57:50 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.29]:50195
	"EHLO NA01-BL2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141Ab3AHW5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:57:48 -0500
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2013 17:57:48 EST
From: Tom Talpey <ttalpey@microsoft.com>
To: Joe Perches <joe@perches.com>, "J. Bruce Fields" <bfields@fieldses.org>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tom Tucker <tom@ogc.us>, "steved@redhat.com" <steved@redhat.com>
Subject: RE: [PATCH] sunrpc: verbs: Avoid 1kb stack
Thread-Topic: [PATCH] sunrpc: verbs: Avoid 1kb stack
Thread-Index: AQHN7a7zWNb8Mw93GEWukUihUqjx1Zg/u0QAgABN85A=
Date: Tue, 8 Jan 2013 22:52:10 +0000
Message-ID: <614F550557B82C44AC27C492ADA391AA0443C556@TK5EX14MBXC285.redmond.corp.microsoft.com>
References: <1357587696.21481.48.camel@joe-AO722>
	 <20130108144604.GB16343@fieldses.org> <1357668576.12749.55.camel@joe-AO722>
In-Reply-To: <1357668576.12749.55.camel@joe-AO722>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.35]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(377424002)(51704002)(24454001)(13464002)(53806001)(44976002)(59766001)(23726001)(74662001)(55846006)(77982001)(31966008)(46406002)(51856001)(74502001)(54316002)(54356001)(47446002)(33656001)(76482001)(56776001)(16406001)(47776002)(50986001)(50466001)(4396001)(56816002)(49866001)(47976001)(47736001)(79102001)(46102001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB021;H:TK5EX14HUBC106.redmond.corp.microsoft.com;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 07200C0526
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Tuesday, January 8, 2013 1:10 PM
> To: J. Bruce Fields
> Cc: Trond Myklebust; David S. Miller; linux-nfs@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Tom Tucker;
> steved@redhat.com; Tom Talpey
> Subject: Re: [PATCH] sunrpc: verbs: Avoid 1kb stack
> 
> On Tue, 2013-01-08 at 09:46 -0500, J. Bruce Fields wrote:
> > On Mon, Jan 07, 2013 at 11:41:36AM -0800, Joe Perches wrote:
> > > 16 * 64 is a bit much.
> > > Use kmalloc_array instead.
> >
> > I thought there was some reason we didn't do this.

The value of RPCRDMA_MAX_DATA_SEGS appears to have been increased to allow 256KB operations (64 pages). Not all requests will need this, so you may want to consider dynamically allocating the array only when it's relatively large (*nsegs is >8, perhaps).

IIRC, the ib_phys_buf array is only built because it's passed to the FastRegister verb as a parameter. It's not needed by the xprtrdma layer.

> >
> > Grepping up through the callers....  It looks like the result is
> > xprt_rdma_send_request returns -EIO, and as far as I can tell that gets
> > passed up to the application on the client.   That doesn't sound right.
> 
> No worries, it was just a warning I noticed when I did an allmodconfig
> compilation.
> 
> Perhaps a comment there might be appropriate instead.
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab1HFOkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 10:40:13 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44292 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab1HFOkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 10:40:09 -0400
Date: Sat, 6 Aug 2011 10:39:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joe Jin <joe.jin@oracle.com>
Cc: Daniel Stodden <daniel.stodden@citrix.com>,
        Jens Axboe <jaxboe@fusionio.com>, Annie Li <annie.li@oracle.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 1/3] xen-blkback: add remove_requested to xen_blkif
 and some declares
Message-ID: <20110806143950.GA29514@dumpdata.com>
References: <4E3A486D.7060506@oracle.com>
 <4E3A48FD.8060807@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3A48FD.8060807@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E3D523E.004C:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 03:23:41PM +0800, Joe Jin wrote:
> 
> Add remove_requested to xen_blkif and some declares.

By itself this patch is a bit strange. If you look in
Documentation/SubmittingPatches:
"2) Describe your changes.

Describe the technical detail of the change(s) your patch includes.
"

There is no really technical details. As in, why is this patch neccessary.

That document also states:
"3) Separate your changes.

Separate _logical changes_ into a single patch file.

For example, if your changes include both bug fixes and performance
enhancements for a single driver, separate those changes into two
or more patches.  If your changes include an API update, and a new
driver which uses that new API, separate those into two patches."


This patch by itself has no logical purpose - as in it does not fix a bug,
or add a new feature - it just plops a new element in a structure, provides
two function decleration of non-existing functions and a maccro that is not
used.

Soo.  Looking at the three patches I believe some reshuffling ought to be done.
If you recall my comments:


        >  	case XenbusStateUnknown:
        > -		/* implies blkif_disconnect() via blkback_remove() */
        > +		/* implies xen_blkif_disconnect() via blkback_remove() */

        Ok, that is not part of this patch. You should create another commit which
        does this type of cleanup and
        >  		device_unregister(&dev->dev);
        >  		break;
        >  
        > @@ -620,6 +778,8 @@ static void frontend_changed(struct xenbus_device *dev,
        >  				 frontend_state);
        >  		break;
        >  	}
        > +
        > +	DPRINTK("%s: %s", dev->nodename, xenbus_strstate(dev->state));

        .. also for this.
        >  }
        >  

I am not sure if it is not clear, but what I meant that those two changes
(the comment rename and adding the DPRINKT) should be as a seperate
patch. So take those changes from patch #3 out and make a new patch.

Read on..
> 
> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> Cc: Daniel Stodden <daniel.stodden@citrix.com>
> Cc: Jens Axboe <jaxboe@fusionio.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Annie Li <annie.li@oracle.com>
> Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>
> ---
>  drivers/block/xen-blkback/common.h |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
> index 9e40b28..acda757 100644
> --- a/drivers/block/xen-blkback/common.h
> +++ b/drivers/block/xen-blkback/common.h
> @@ -49,6 +49,7 @@
>  	pr_debug(DRV_PFX "(%s:%d) " fmt ".\n",	\
>  		 __func__, __LINE__, ##args)
>  
> +#define WPRINTK(fmt, args...) printk(KERN_WARNING "xen-blkback: " fmt, ##args)

This is what I said in my review

        "What is 'WPRITNK' ? Can you use the the same type of printks
        as the rest? Also you have a space at the end. Make sure to
        run checkpath.pl"

which honeselty I should have been more specific. I meant that
you could just convert all the "WPRINTK" to what they define.

As in, sed/WPRINT/printk(KERN_WARNING/..

In essence, what I would like you to do is:

1). Read up on Documentation/SubmittingPatches
2). Squash this patch (except the declerations of the functions that are
    implemented in patch #3) into patch #2. The declerations of functions
    should be squashed in patch #3.
3). Replace in patch #3 all calls to WPRINTK with printk(KERN_WARNING.
4). Create a new patch that deals with the addition of DPRINTK
    and the update of the comment (see above).
5). The total should be three patches:
    a). This patch squashed with patch #2 (with the modification described in 2).
    b). Patch #3 modified
    c). A new patch with the debug/comments modifications.
6). Make sure each patch compiles on its own.
7). Resend - or if you want to double check with me in case I've further
    comments - just send it to me privately.

>  
>  /* Not a real protocol.  Used to generate ring structs which contain
>   * the elements common to all protocols only.  This way we get a
> @@ -145,6 +146,7 @@ struct xen_blkif {
>  	/* Back pointer to the backend_info. */
>  	struct backend_info	*be;
>  	/* Private fields. */
> +	bool			remove_requested;
>  	spinlock_t		blk_ring_lock;
>  	atomic_t		refcnt;
>  
> @@ -198,6 +200,9 @@ int xen_blkbk_flush_diskcache(struct xenbus_transaction xbt,
>  
>  struct xenbus_device *xen_blkbk_xenbus(struct backend_info *be);
>  
> +void xen_vbd_sync(struct xen_vbd *vbd);
> +void xen_blkback_close(struct xen_blkif *blkif);
> +
>  static inline void blkif_get_x86_32_req(struct blkif_request *dst,
>  					struct blkif_x86_32_request *src)
>  {

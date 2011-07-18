Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab1GRIrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 04:47:31 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:50552 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab1GRIra convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Mon, 18 Jul 2011 04:47:30 -0400
Message-Id: <4E240F3D020000780004DD70@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 18 Jul 2011 09:47:25 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ian Campbell" <Ian.Campbell@eu.citrix.com>,
        "Keir Fraser" <keir.xen@gmail.com>
Cc: "olaf@aepfle.de" <olaf@aepfle.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keir@xen.org" <keir@xen.org>
Subject: Re: [Xen-devel] [PATCH] xen: update machine_to_phys_order on
	 resume
References: <CA499EDA.1E10E%keir.xen@gmail.com>
 <1310977905.20648.26.camel@zakaz.uk.xensource.com>
In-Reply-To: <1310977905.20648.26.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 18.07.11 at 10:31, Ian Campbell <Ian.Campbell@eu.citrix.com> wrote:
> Pushing things down at build time is pretty easy. FWIW here's an
> incomplete patch to push the kernel declared features down into the
> hypervisor at build time extracted from some old PV in HVM container
> stuff (so not directly applicable). I can bring it up to date if the
> approach seems useful.

Yes, that looks like what we'd want from a conceptual perspective,
but...

> One thing which is somewhat missing is user control of non-mandatory
> features declared by a kernel, although normally that should be a
> decision made by the tools/hypervisor based upon available features etc.
> 
> diff -r a6c4d03b7d45 tools/libxc/xc_dom_core.c
> --- a/tools/libxc/xc_dom_core.c	Mon Feb 08 13:05:48 2010 +0000
> +++ b/tools/libxc/xc_dom_core.c	Thu Feb 11 12:48:47 2010 +0000
> @@ -609,6 +609,7 @@
>  
>  int xc_dom_parse_image(struct xc_dom_image *dom)
>  {
> +    DECLARE_DOMCTL;
>      int i;
>  
>      xc_dom_printf("%s: called\n", __FUNCTION__);
> @@ -629,8 +630,26 @@
>      /* check features */
>      for ( i = 0; i < XENFEAT_NR_SUBMAPS; i++ )
>      {
> -        dom->f_active[i] |= dom->f_requested[i]; /* cmd line */
> -        dom->f_active[i] |= dom->parms.f_required[i]; /* kernel   */
> +        domctl.cmd = XEN_DOMCTL_setfeatures;
> +        domctl.domain = dom->guest_domid;
> +
> +        domctl.u.setfeatures.submap_idx = i;
> +        domctl.u.setfeatures.submap = 0;
> +
> +        domctl.u.setfeatures.submap |= dom->f_requested[i]; /* cmd line */
> +        domctl.u.setfeatures.submap |= dom->parms.f_required[i]; /* kernel   */
> +
> +        xc_dom_printf("requesting features[%d] = %#x\n", domctl.u.setfeatures.submap_idx, domctl.u.setfeatures.submap);
> +        if (do_domctl(dom->guest_xc, &domctl))
> +        {
> +            xc_dom_panic(XC_INVALID_PARAM,
> +                         "%s: unable to set requested features\n", __FUNCTION__);
> +            goto err;
> +        }
> +
> +        xc_dom_printf("received   features[%d] = %#x\n", domctl.u.setfeatures.submap_idx, domctl.u.setfeatures.submap);
> +        dom->f_active[i] = domctl.u.setfeatures.submap;
> +
>          if ( (dom->f_active[i] & dom->parms.f_supported[i]) !=
>               dom->f_active[i] )
>          {
> @@ -639,6 +658,7 @@
>              goto err;
>          }
>      }
> +
>      return 0;
>  
>   err:
> diff -r a6c4d03b7d45 tools/libxl/xl.c
> --- a/tools/libxl/xl.c	Mon Feb 08 13:05:48 2010 +0000
> +++ b/tools/libxl/xl.c	Thu Feb 11 12:48:47 2010 +0000
> @@ -468,6 +468,8 @@
>          }
>          if (config_lookup_string (&config, "ramdisk", &buf) == CONFIG_TRUE)
>              b_info->u.pv.ramdisk = strdup(buf);
> +        if (config_lookup_string (&config, "features", &buf) == CONFIG_TRUE)
> +            b_info->u.pv.features = strdup(buf);
>      }
>  
>      if ((vbds = config_lookup (&config, "disk")) != NULL) {
> diff -r a6c4d03b7d45 xen/common/domctl.c
> --- a/xen/common/domctl.c	Mon Feb 08 13:05:48 2010 +0000
> +++ b/xen/common/domctl.c	Thu Feb 11 12:48:47 2010 +0000
> @@ -23,6 +23,7 @@
>  #include <xen/paging.h>
>  #include <asm/current.h>
>  #include <public/domctl.h>
> +#include <public/features.h>
>  #include <xsm/xsm.h>
>  
>  static DEFINE_SPINLOCK(domctl_lock);
> @@ -960,6 +962,54 @@
>      }
>      break;
>  
> +    case XEN_DOMCTL_setfeatures:
> +    {
> +        struct domain *d;
> +        ret = -ESRCH;
> +        if ( (d = rcu_lock_domain_by_id(op->domain)) != NULL )
> +        {
> +            printk("dom%d set features[%d] = %#x\n", d->domain_id, op->u.setfeatures.submap_idx, op->u.setfeatures.submap);
> +
> +            switch (op->u.setfeatures.submap_idx) {
> +            case 0:
> +                if ( !paging_mode_translate(d) )

... this condition looks inverted to me.

> +                {
> +                    op->u.setfeatures.submap &= ~(1U<<XENFEAT_writable_page_tables);
> +                    op->u.setfeatures.submap &= ~(1U<<XENFEAT_auto_translated_physmap);
> +                }
> +                if ( !is_pvhvm_domain(d) )
> +                {
> +                    op->u.setfeatures.submap &= ~(1U<<XENFEAT_supervisor_mode_kernel);
> +                }
> +
> +                op->u.setfeatures.submap &= ~(1U<<XENFEAT_writable_descriptor_tables);

Why do you turn this off unconditionally?

> +
> +                /* XXX other features */

That's perhaps also the place holder where the passed in information
would actually get stored?

Jan

> +
> +
> +                if ( op->u.setfeatures.submap &(1U<<XENFEAT_supervisor_mode_kernel) )
> +                    d->arch.pv_kernel_minimum_rpl = 0;
> +
> +                ret = 0;
> +                break;
> +
> +            default:
> +                printk("dom%d unknown feature submap %d\n", d->domain_id, op->u.setfeatures.submap_idx);
> +                op->u.setfeatures.submap = 0;
> +                ret = -EINVAL;
> +                break;
> +            }
> +
> +            rcu_unlock_domain(d);
> +            ret = 0;
> +
> +            if ( copy_to_guest(u_domctl, op, 1) )
> +                ret = -EFAULT;
> +
> +        }
> +    }
> +    break;
> +
>      default:
>          ret = arch_do_domctl(op, u_domctl);
>          break;
> diff -r a6c4d03b7d45 xen/include/public/domctl.h
> --- a/xen/include/public/domctl.h	Mon Feb 08 13:05:48 2010 +0000
> +++ b/xen/include/public/domctl.h	Thu Feb 11 12:48:47 2010 +0000
> @@ -169,6 +169,13 @@
>      XEN_GUEST_HANDLE_64(xen_pfn_t) array;
>  };
>  
> +/* XEN_DOMCTL_setfeatures */
> +struct xen_domctl_setfeatures {
> +    /* IN variables */
> +    unsigned int submap_idx;    /* which 32-bit submap to return */
> +    /* IN/OUT variables */
> +    uint32_t     submap;        /* 32-bit submap, updated with actual 
> result. */
> +};
>  
>  /*
>   * Control shadow pagetables operation
> @@ -842,6 +848,7 @@
>  #define XEN_DOMCTL_gettscinfo                    59
>  #define XEN_DOMCTL_settscinfo                    60
>  #define XEN_DOMCTL_getpageframeinfo3             61
> +#define XEN_DOMCTL_setfeatures	                 62
>  #define XEN_DOMCTL_gdbsx_guestmemio            1000
>  #define XEN_DOMCTL_gdbsx_pausevcpu             1001
>  #define XEN_DOMCTL_gdbsx_unpausevcpu           1002
> @@ -855,6 +862,7 @@
>          struct xen_domctl_getpageframeinfo  getpageframeinfo;
>          struct xen_domctl_getpageframeinfo2 getpageframeinfo2;
>          struct xen_domctl_getpageframeinfo3 getpageframeinfo3;
> +        struct xen_domctl_setfeatures		setfeatures;
>          struct xen_domctl_vcpuaffinity      vcpuaffinity;
>          struct xen_domctl_shadow_op         shadow_op;
>          struct xen_domctl_max_mem           max_mem;



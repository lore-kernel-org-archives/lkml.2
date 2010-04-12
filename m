Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab0DLL1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 07:27:06 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44546 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840Ab0DLL1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 07:27:02 -0400
Subject: Re: 2.6.34-rc2: "ima_dec_counts: open/free imbalance"?
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Eric Paris <eparis@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mimi Zohar <zohar@us.ibm.com>, James Morris <jmorris@namei.org>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>
In-Reply-To: <25D576C5-F4E5-49BF-A20C-361214155BBA@m3y3r.de>
References: <1269775909.5301.4.camel@localhost.localdomain>
	 <20100331163234.8e875ae8.akpm@linux-foundation.org>
	 <1270089696.2941.217.camel@dhcp235-240.rdu.redhat.com>
	 <25D576C5-F4E5-49BF-A20C-361214155BBA@m3y3r.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 07:27:00 -0400
Message-ID: <1271071620.3125.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 20:17 +0200, Thomas Meyer wrote:
> Am 01.04.2010 um 04:41 schrieb Eric Paris <eparis@redhat.com>:
> 
> > On Wed, 2010-03-31 at 16:32 -0700, Andrew Morton wrote:
> >> On Sun, 28 Mar 2010 13:31:49 +0200
> >> Thomas Meyer <thomas@m3y3r.de> wrote:
> >>
> >>> This warning/error/notice is new in 2.6.34-rc2+:
> >>
> >> Let's add some cc's.  It might be a DRM bug.
> >>
> >> I'll ask Rafael and Maciej to track this as a post-2.6.33 regression,
> >> thanks.
> >
> > The IMA code hasn't changed since .33 so my guess is something new the
> > drm code is doing with obj->filp.
> >
> > Thomas, any idea what the newest kernel was that didn't show you this
> > problem?
> 
> I first saw this message in 2.6.34-rc2 (+free_init_pages patch), but  
> that was also the first bootable kernel for me as I was hit by the  
> NO_BOOTMEM bug...
> 
> >  It might help cut down my search in the morning....
> >
> > -Eric
> >

The call to shmem_file_setup() in drm_gem_object_alloc() should properly
increment the IMA counters and the fput() in
drm_gem_object_free_common() should decrement them.

I noticed the 'bump' comment in 'include/drm/drmP.h' doesn't match the
code, but in fact does the exact opposite.  Not sure if this is related.

static inline void
drm_gem_object_handle_unreference(struct drm_gem_object *obj)
{
        if (obj == NULL)
                return;

        /*
         * Must bump handle count first as this may be the last
         * ref, in which case the object would disappear before we
         * checked for a name
         */
        kref_put(&obj->handlecount, drm_gem_object_handle_free);
        drm_gem_object_unreference(obj);
}

Mimi


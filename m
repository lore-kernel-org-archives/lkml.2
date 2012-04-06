Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab2DFUfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 16:35:04 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:41584 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490Ab2DFUfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 16:35:01 -0400
Subject: Re: [PATCH 1/2] drm/i915: fix integer overflow in i915_gem_execbuffer2()
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <1333741246_275838@CP5-2952>
Date: Fri, 6 Apr 2012 16:34:58 -0400
Cc: Keith Packard <keithp@keithp.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Transfer-Encoding: 7bit
Message-Id: <18784666-9A03-48C2-87DA-BEC78D79C993@gmail.com>
References: <1333717099-32679-1-git-send-email-xi.wang@gmail.com> <1333719431_271283@CP5-2952> <B6B08A4C-2FEA-4C08-AB2F-4A99FB8D3786@gmail.com> <1333720475_271533@CP5-2952> <5065822E-8C69-442E-A59C-98D6C27B289D@gmail.com> <1333723480_272185@CP5-2952> <507CC69B-BD9C-421B-9107-B3284BEB116E@gmail.com> <1333741246_275838@CP5-2952>
To: Chris Wilson <chris@chris-wilson.co.uk>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 6, 2012, at 3:40 PM, Chris Wilson wrote:
> On Fri, 6 Apr 2012 14:17:41 -0400, Xi Wang <xi.wang@gmail.com> wrote:
>> 
>> Why an attempt to vmalloc?  The overflow check in drm_malloc_ab()
>> will simply return NULL and fail the ioctl with -ENOMEM.
> 
> It's an invalid value for the ioctl and should be treated as such, not
> making ENOMEM more ambiguous.

We could copy and paste the overflow check so as to return -EINVAL.
I just doubt how much that would help --- you can find existing usages
in other functions, for example, in i915_gem_execbuffer():

  /* Copy in the exec list from userland */
  exec_list = drm_malloc_ab(sizeof(*exec_list), args->buffer_count);
  exec2_list = drm_malloc_ab(sizeof(*exec2_list), args->buffer_count);
  if (exec_list == NULL || exec2_list == NULL) {
          DRM_DEBUG("Failed to allocate exec list for %d buffers\n",
                    args->buffer_count);
          drm_free_large(exec_list);
          drm_free_large(exec2_list);
          return -ENOMEM;
  }

Should we fix all these as well by repeating the checks and returning
-EINVAL?  I am worried about the code bloat / readability price you
would pay for getting a different error code.

BTW, I've also seen code using E2BIG.  Any documented guideline?

- xi


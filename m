Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab1KPCdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 21:33:09 -0500
Received: from ozlabs.org ([203.10.76.45]:38819 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075Ab1KPCdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 21:33:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH] virtio-mmio: Devices parameter parsing
In-Reply-To: <1321365185-2928-1-git-send-email-pawel.moll@arm.com>
References: <1321365185-2928-1-git-send-email-pawel.moll@arm.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 16 Nov 2011 11:12:05 +1030
Message-ID: <87sjlooq3m.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Nov 2011 13:53:05 +0000, Pawel Moll <pawel.moll@arm.com> wrote:
> +static char *virtio_mmio_cmdline_devices;
> +module_param_named(devices, virtio_mmio_cmdline_devices, charp, 0);

This is the wrong way to do this.

Don't put things in a charp and process it later.  It's lazy.  You
should write parsers for it and call it straight from module_param.

And if you do it that way, multiple devices are simply multiple
arguments.

Like so:

static int virtio_mmio_set(const char *val, const struct kernel_param *kp)
{
        if (!virtio_mmio_cmdline_parent_initialized) {
        	err = device_register(&virtio_mmio_cmdline_parent);
        	if (err)
        		return err;
                virtio_mmio_cmdline_parent_initialized = true;
        }
        
        ... parse here, return -errno on fail, 0 on success.
}

static struct kernel_param_ops param_ops_virtio_mmio = {
        .set = virtio_mmio_set,
        .get = virtio_mmio_get,
};

module_param_cb(device, &param_ops_virtio_mmio, NULL, 0400);

Initialization and error handling is now done for you...

Cheers,
Rusty.

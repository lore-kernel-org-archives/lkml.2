Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab2KZWPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 17:15:09 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:41855 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab2KZWPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 17:15:07 -0500
MIME-Version: 1.0
In-Reply-To: <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
	<1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>
Date: Tue, 27 Nov 2012 08:15:06 +1000
Message-ID: <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
From: Dave Airlie <airlied@gmail.com>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: thierry.reding@avionic-design.de, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Arto Merilainen <amerilainen@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static int tegra_drm_open(struct drm_device *drm, struct drm_file *filp)
>  {
> -       return 0;
> +       struct tegra_drm_fpriv *fpriv;
> +       int err = 0;
> +
> +       fpriv = kzalloc(sizeof(*fpriv), GFP_KERNEL);
> +       if (!fpriv)
> +               return -ENOMEM;
> +
> +       INIT_LIST_HEAD(&fpriv->contexts);
> +       filp->driver_priv = fpriv;
> +

who frees this?
> +struct tegra_drm_syncpt_incr_args {
> +       __u32 id;
> +};

add 32-bits of padding here

> +
> +struct tegra_drm_syncpt_wait_args {
> +       __u32 id;
> +       __u32 thresh;
> +       __s32 timeout;
> +       __u32 value;
> +};
> +
> +#define DRM_TEGRA_NO_TIMEOUT   (-1)
> +
> +struct tegra_drm_open_channel_args {
> +       __u32 class;
> +       void *context;

no pointers use u64, align them to 64-bits, so 32-bits of padding,

> +};
> +
> +struct tegra_drm_get_channel_param_args {
> +       void *context;
> +       __u32 value;

Same padding + uint64_t for void *

> +};
> +
> +struct tegra_drm_syncpt_incr {
> +       __u32 syncpt_id;
> +       __u32 syncpt_incrs;
> +};
> +
> +struct tegra_drm_cmdbuf {
> +       __u32 mem;
> +       __u32 offset;
> +       __u32 words;
> +};

add padding
> +
> +struct tegra_drm_reloc {
> +       __u32 cmdbuf_mem;
> +       __u32 cmdbuf_offset;
> +       __u32 target;
> +       __u32 target_offset;
> +       __u32 shift;
> +};

add padding

> +
> +struct tegra_drm_waitchk {
> +       __u32 mem;
> +       __u32 offset;
> +       __u32 syncpt_id;
> +       __u32 thresh;
> +};
> +
> +struct tegra_drm_submit_args {
> +       void *context;
> +       __u32 num_syncpt_incrs;
> +       __u32 num_cmdbufs;
> +       __u32 num_relocs;
> +       __u32 submit_version;
> +       __u32 num_waitchks;
> +       __u32 waitchk_mask;
> +       __u32 timeout;
> +       struct tegra_drm_syncpt_incrs *syncpt_incrs;
> +       struct tegra_drm_cmdbuf *cmdbufs;
> +       struct tegra_drm_reloc *relocs;
> +       struct tegra_drm_waitchk *waitchks;
> +
> +       __u32 pad[5];           /* future expansion */
> +       __u32 fence;            /* Return value */
> +};

lose all the pointers for 64-bit aligned uint64_t.

Probably should align all of these on __u64 and __u32 usage if possible.

i'll look at the rest of the patches, but I need to know what commands
can be submitted via this interface and what are the security
implications of it.

Dave.

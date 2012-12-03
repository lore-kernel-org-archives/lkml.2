Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab2LCJaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 04:30:12 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46382 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab2LCJaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 04:30:09 -0500
Message-ID: <50BC7118.9060407@gmail.com>
Date: Mon, 03 Dec 2012 17:30:00 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Terje Bergstrom <tbergstrom@nvidia.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com> <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>
In-Reply-To: <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave:

I'm new in kernel development. Could you tell me or give me some
materials to read that why we need to align the size of IOCTL structures
to 64bit? I can understand if we're working in a 64bit kernel but why we
need to do this if we're in a 32bit arm kernel? Besides, why the
pointers in IOCTL structure should be declared as u64?

Mark
On 11/27/2012 06:15 AM, Dave Airlie wrote:
>>  static int tegra_drm_open(struct drm_device *drm, struct drm_file *filp)
>>  {
>> -       return 0;
>> +       struct tegra_drm_fpriv *fpriv;
>> +       int err = 0;
>> +
>> +       fpriv = kzalloc(sizeof(*fpriv), GFP_KERNEL);
>> +       if (!fpriv)
>> +               return -ENOMEM;
>> +
>> +       INIT_LIST_HEAD(&fpriv->contexts);
>> +       filp->driver_priv = fpriv;
>> +
> 
> who frees this?
>> +struct tegra_drm_syncpt_incr_args {
>> +       __u32 id;
>> +};
> 
> add 32-bits of padding here
> 
>> +
>> +struct tegra_drm_syncpt_wait_args {
>> +       __u32 id;
>> +       __u32 thresh;
>> +       __s32 timeout;
>> +       __u32 value;
>> +};
>> +
>> +#define DRM_TEGRA_NO_TIMEOUT   (-1)
>> +
>> +struct tegra_drm_open_channel_args {
>> +       __u32 class;
>> +       void *context;
> 
> no pointers use u64, align them to 64-bits, so 32-bits of padding,
> 
>> +};
>> +
>> +struct tegra_drm_get_channel_param_args {
>> +       void *context;
>> +       __u32 value;
> 
> Same padding + uint64_t for void *
> 
>> +};
>> +
>> +struct tegra_drm_syncpt_incr {
>> +       __u32 syncpt_id;
>> +       __u32 syncpt_incrs;
>> +};
>> +
>> +struct tegra_drm_cmdbuf {
>> +       __u32 mem;
>> +       __u32 offset;
>> +       __u32 words;
>> +};
> 
> add padding
>> +
>> +struct tegra_drm_reloc {
>> +       __u32 cmdbuf_mem;
>> +       __u32 cmdbuf_offset;
>> +       __u32 target;
>> +       __u32 target_offset;
>> +       __u32 shift;
>> +};
> 
> add padding
> 
>> +
>> +struct tegra_drm_waitchk {
>> +       __u32 mem;
>> +       __u32 offset;
>> +       __u32 syncpt_id;
>> +       __u32 thresh;
>> +};
>> +
>> +struct tegra_drm_submit_args {
>> +       void *context;
>> +       __u32 num_syncpt_incrs;
>> +       __u32 num_cmdbufs;
>> +       __u32 num_relocs;
>> +       __u32 submit_version;
>> +       __u32 num_waitchks;
>> +       __u32 waitchk_mask;
>> +       __u32 timeout;
>> +       struct tegra_drm_syncpt_incrs *syncpt_incrs;
>> +       struct tegra_drm_cmdbuf *cmdbufs;
>> +       struct tegra_drm_reloc *relocs;
>> +       struct tegra_drm_waitchk *waitchks;
>> +
>> +       __u32 pad[5];           /* future expansion */
>> +       __u32 fence;            /* Return value */
>> +};
> 
> lose all the pointers for 64-bit aligned uint64_t.
> 
> Probably should align all of these on __u64 and __u32 usage if possible.
> 
> i'll look at the rest of the patches, but I need to know what commands
> can be submitted via this interface and what are the security
> implications of it.
> 
> Dave.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

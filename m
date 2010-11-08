Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab0KHXIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:08:42 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:51616 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab0KHXIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:08:41 -0500
Subject: Re: [Intel-gfx] [bisected] offset display bug in i915
From: Jon Masters <jonathan@jonmasters.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <5b55a1$ijk39t@fmsmga002.fm.intel.com>
References: <1289211512.3916.383.camel@constitution.bos.jonmasters.org>
	 <b9dded$h0q3am@orsmga002.jf.intel.com>
	 <1289213695.3916.396.camel@constitution.bos.jonmasters.org>
	 <1289215364.3916.400.camel@constitution.bos.jonmasters.org>
	 <1289215749.3916.401.camel@constitution.bos.jonmasters.org>
	 <5b55a1$ijk39t@fmsmga002.fm.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 08 Nov 2010 18:08:47 -0500
Message-ID: <1289257727.3916.429.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 12:13 +0000, Chris Wilson wrote:
> On Mon, 08 Nov 2010 06:29:09 -0500, Jon Masters <jonathan@jonmasters.org> wrote:
> > On Mon, 2010-11-08 at 06:22 -0500, Jon Masters wrote:
> > > As I mentioned on IRC, I'm familiar with how I2C works electrically, and
> > > therefore EDID implementation as a concept, but I am not really a
> > > graphics hacker so I wasn't aware that you prefer edid-decode :)
> > > 
> > > Here is a decoded version of the output:
> > 
> > And here is an old file I had with the output when running a broken
> > kernel with the cacheing enabled:
> 
> They look to be identical. So it is not necessarily the caching that is
> the issue, but that we now no longer do an essential step whilst bringing
> up the lvds. Can you just check that the reported EDIDs are the same for
> when it is behaving correctly and when the display is offset?
> 
> The secondary change in the commit was to use drm_get_edid() directly
> during device detection which delayed setting the EDID property on the
> connection until get_modes(). Does this make a difference?
> 
> diff --git a/drivers/gpu/drm/i915/intel_lvds.c
> b/drivers/gpu/drm/i915/intel_lvds
> index f1a6499..17bcb7d 100644
> --- a/drivers/gpu/drm/i915/intel_lvds.c
> +++ b/drivers/gpu/drm/i915/intel_lvds.c
> @@ -940,7 +940,10 @@ void intel_lvds_init(struct drm_device *dev)
>         intel_lvds->edid = drm_get_edid(connector,
>                                         &dev_priv->gmbus[pin].adapter);
>  
> -       if (!intel_lvds->edid) {
> +       if (intel_lvds->edid) {
> +               drm_mode_connector_update_edid_property(connector,
> +                                                       intel_lvds->edid);
> +       } else {

I tried this, which didn't work. Then I added this (ignore stupid
evolution formatting - convenient for email backlog, but not mutt):

diff --git a/drivers/gpu/drm/i915/intel_lvds.c
b/drivers/gpu/drm/i915/intel_lvds.c
index 17bcb7d..a0bb443 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -462,6 +462,14 @@ intel_lvds_detect(struct drm_connector *connector,
bool force)
 {
        struct drm_device *dev = connector->dev;
        enum drm_connector_status status = connector_status_connected;
+       /* JCM - added this */
+       struct drm_i915_private *dev_priv = dev->dev_private;
+       u8 pin = GMBUS_PORT_PANEL;
+       struct edid *edid = drm_get_edid(connector,
&dev_priv->gmbus[pin].adapter);
+
+       /* I was asked to free in here */
+       if (edid)
+               kfree(edid);
 
        /* ACPI lid methods were generally unreliable in this
generation, so
         * don't even bother.

Which should have made the edid always get freed on detect. That didn't
work either. I might wind up learning something about the DRM stack.

Anyway. Here's the reg dumper output. First, for a busticated kernel:

[jcm@constitution ~]$ cat intel_regs_broken.txt 
                 DCC: 0x00200020 (single channel, XOR randomization:
enabled, XOR bit: 11)
           CHDECMISC: 0x42000064 (XOR bank, ch2 enh disabled, ch1 enh
disabled, ch0 enh enabled, flex disabled, ep not present)
              C0DRB0: 0x00200020 (0x0020)
              C0DRB1: 0x00200020 (0x0020)
              C0DRB2: 0x00200020 (0x0020)
              C0DRB3: 0x00880020 (0x0020)
              C1DRB0: 0x00000000 (0x0000)
              C1DRB1: 0x00000000 (0x0000)
              C1DRB2: 0x00000000 (0x0000)
              C1DRB3: 0x00000000 (0x0000)
             C0DRA01: 0x00000088 (0x0088)
             C0DRA23: 0x00000000 (0x0000)
             C1DRA01: 0x00000000 (0x0000)
             C1DRA23: 0x00000000 (0x0000)
          PGETBL_CTL: 0x00000001
   VCLK_DIVISOR_VGA0: 0x00200074 (n = 32, m1 = 0, m2 = 52)
   VCLK_DIVISOR_VGA1: 0x00200074 (n = 32, m1 = 0, m2 = 52)
       VCLK_POST_DIV: 0x00800100 (vga0 p1 = 2, p2 = 2, vga1 p1 = 3, p2 =
2)
           DPLL_TEST: 0x00010001 ()
        CACHE_MODE_0: 0x00006820
             D_STATE: 0x0000000b
       DSPCLK_GATE_D: 0x00000000 (clock gates disabled:)
      RENCLK_GATE_D1: 0x00000000
      RENCLK_GATE_D2: 0x00000000
               SDVOB: 0x00300000 (disabled, pipe A, stall disabled, not
detected)
               SDVOC: 0x00300000 (disabled, pipe A, stall disabled, not
detected)
             SDVOUDI: 0x00000000
              DSPARB: 0x00001d9c
              DSPFW1: 0xf1830f0f
              DSPFW2: 0x0000030f
              DSPFW3: 0x6700018f
                ADPA: 0x40008c18 (disabled, pipe B, +hsync, +vsync)
                LVDS: 0xc0308300 (enabled, pipe B, 18 bit, 1 channel)
                DVOA: 0x00000000 (disabled, pipe A, no stall, -hsync,
-vsync)
                DVOB: 0x00300000 (disabled, pipe A, no stall, -hsync,
-vsync)
                DVOC: 0x00300000 (disabled, pipe A, no stall, -hsync,
-vsync)
         DVOA_SRCDIM: 0x00000000
         DVOB_SRCDIM: 0x00000000
         DVOC_SRCDIM: 0x00000000
          PP_CONTROL: 0x00000001 (power target: on)
           PP_STATUS: 0xc0000008 (on, ready, sequencing idle)
        PP_ON_DELAYS: 0x025807d0
       PP_OFF_DELAYS: 0x01f407d0
          PP_DIVISOR: 0x00209d05
        PFIT_CONTROL: 0x00000008
     PFIT_PGM_RATIOS: 0x00000000
     PORT_HOTPLUG_EN: 0x00000220
   PORT_HOTPLUG_STAT: 0x00001000
            DSPACNTR: 0xd9000000 (enabled, pipe B)
          DSPASTRIDE: 0x00001000 (4096 bytes)
             DSPAPOS: 0x00000000 (0, 0)
            DSPASIZE: 0x025703ff (1024, 600)
            DSPABASE: 0x00830000
            DSPASURF: 0x00000000
         DSPATILEOFF: 0x00000000
           PIPEACONF: 0x00000000 (disabled, single-wide)
            PIPEASRC: 0x027f01df (640, 480)
           PIPEASTAT: 0x00000000 (status:)
   PIPEA_GMCH_DATA_M: 0x00000000
   PIPEA_GMCH_DATA_N: 0x00000000
     PIPEA_DP_LINK_M: 0x00000000
     PIPEA_DP_LINK_N: 0x00000000
       CURSOR_A_BASE: 0x00000000
    CURSOR_A_CONTROL: 0x00000000
   CURSOR_A_POSITION: 0x00000000
                FPA0: 0x00200074 (n = 32, m1 = 0, m2 = 52)
                FPA1: 0x00200074 (n = 32, m1 = 0, m2 = 52)
              DPLL_A: 0x04800000 (disabled, non-dvo, VGA, default clock,
DAC/serial mode, p1 = 9, p2 = 10, SDVO mult 1)
           DPLL_A_MD: 0x00000000
            HTOTAL_A: 0x031f027f (640 active, 800 total)
            HBLANK_A: 0x03170287 (648 start, 792 end)
             HSYNC_A: 0x02ef028f (656 start, 752 end)
            VTOTAL_A: 0x020c01df (480 active, 525 total)
            VBLANK_A: 0x020401e7 (488 start, 517 end)
             VSYNC_A: 0x01eb01e9 (490 start, 492 end)
           BCLRPAT_A: 0x00000000
        VSYNCSHIFT_A: 0x00000000
            DSPBCNTR: 0x49000000 (disabled, pipe B)
          DSPBSTRIDE: 0x00000280 (640 bytes)
             DSPBPOS: 0x00000000 (0, 0)
            DSPBSIZE: 0x018f02cf (720, 400)
            DSPBBASE: 0x00000000
            DSPBSURF: 0x00000000
         DSPBTILEOFF: 0x00000000
           PIPEBCONF: 0x80000000 (enabled, single-wide)
            PIPEBSRC: 0x03ff0257 (1024, 600)
           PIPEBSTAT: 0x00400202 (status: LBLC_EVENT_ENABLE
VSYNC_INT_STATUS VBLANK_INT_STATUS)
   PIPEB_GMCH_DATA_M: 0x00000000
   PIPEB_GMCH_DATA_N: 0x00000000
     PIPEB_DP_LINK_M: 0x00000000
     PIPEB_DP_LINK_N: 0x00000000
       CURSOR_B_BASE: 0x00000000
    CURSOR_B_CONTROL: 0x10000000
   CURSOR_B_POSITION: 0x012801f9
                FPB0: 0x0020008c (n = 32, m1 = 0, m2 = 12)
                FPB1: 0x0020008c (n = 32, m1 = 0, m2 = 12)
              DPLL_B: 0x98020000 (enabled, non-dvo, default clock, LVDS
mode, p1 = 3, p2 = 14, SDVO mult 1)
           DPLL_B_MD: 0x00000000
            HTOTAL_B: 0x053f03ff (1024 active, 1344 total)
            HBLANK_B: 0x053f03ff (1024 start, 1344 end)
             HSYNC_B: 0x049f0417 (1048 start, 1184 end)
            VTOTAL_B: 0x03250257 (600 active, 806 total)
            VBLANK_B: 0x02d102ab (684 start, 722 end)
             VSYNC_B: 0x02c102bb (700 start, 706 end)
           BCLRPAT_B: 0x00000000
        VSYNCSHIFT_B: 0x00000000
   VCLK_DIVISOR_VGA0: 0x00200074
   VCLK_DIVISOR_VGA1: 0x00200074
       VCLK_POST_DIV: 0x00800100
            VGACNTRL: 0x80000000 (disabled)
              TV_CTL: 0x00000000
              TV_DAC: 0x00000000
            TV_CSC_Y: 0x00000000
           TV_CSC_Y2: 0x00000000
            TV_CSC_U: 0x00000000
           TV_CSC_U2: 0x00000000
            TV_CSC_V: 0x00000000
           TV_CSC_V2: 0x00000000
        TV_CLR_KNOBS: 0x00000000
        TV_CLR_LEVEL: 0x00000000
          TV_H_CTL_1: 0x00000000
          TV_H_CTL_2: 0x00000000
          TV_H_CTL_3: 0x00000000
          TV_V_CTL_1: 0x00000000
          TV_V_CTL_2: 0x00000000
          TV_V_CTL_3: 0x00000000
          TV_V_CTL_4: 0x00000000
          TV_V_CTL_5: 0x00000000
          TV_V_CTL_6: 0x00000000
          TV_V_CTL_7: 0x00000000
         TV_SC_CTL_1: 0x00000000
         TV_SC_CTL_2: 0x00000000
         TV_SC_CTL_3: 0x00000000
          TV_WIN_POS: 0x00000000
         TV_WIN_SIZE: 0x00000000
     TV_FILTER_CTL_1: 0x00000000
     TV_FILTER_CTL_2: 0x00000000
     TV_FILTER_CTL_3: 0x00000000
       TV_CC_CONTROL: 0x00000000
          TV_CC_DATA: 0x00000000
         TV_H_LUMA_0: 0x00000000
        TV_H_LUMA_59: 0x00000000
       TV_H_CHROMA_0: 0x00000000
      TV_H_CHROMA_59: 0x00000000
        FBC_CFB_BASE: 0xffffffff
         FBC_LL_BASE: 0xffffffff
         FBC_CONTROL: 0xffffffff
         FBC_COMMAND: 0xffffffff
          FBC_STATUS: 0xffffffff
        FBC_CONTROL2: 0xffffffff
       FBC_FENCE_OFF: 0xffffffff
         FBC_MOD_NUM: 0xffffffff
             MI_MODE: 0x00000200
        MI_ARB_STATE: 0x00000840
      MI_RDRET_STATE: 0x00000000
             ECOSKPD: 0x00000307
                DP_B: 0x00000000
      DPB_AUX_CH_CTL: 0x00000000
    DPB_AUX_CH_DATA1: 0x00000000
    DPB_AUX_CH_DATA2: 0x00000000
    DPB_AUX_CH_DATA3: 0x00000000
    DPB_AUX_CH_DATA4: 0x00000000
    DPB_AUX_CH_DATA5: 0x00000000
                DP_C: 0x00000000
      DPC_AUX_CH_CTL: 0x00000000
    DPC_AUX_CH_DATA1: 0x00000000
    DPC_AUX_CH_DATA2: 0x00000000
    DPC_AUX_CH_DATA3: 0x00000000
    DPC_AUX_CH_DATA4: 0x00000000
    DPC_AUX_CH_DATA5: 0x00000000
                DP_D: 0x00000000
      DPD_AUX_CH_CTL: 0x00000000
    DPD_AUX_CH_DATA1: 0x00000000
    DPD_AUX_CH_DATA2: 0x00000000
    DPD_AUX_CH_DATA3: 0x00000000
    DPD_AUX_CH_DATA4: 0x00000000
    DPD_AUX_CH_DATA5: 0x00000000
          AUD_CONFIG: 0x00000000
    AUD_HDMIW_STATUS: 0x00000000
      AUD_CONV_CHCNT: 0x00000000
       VIDEO_DIP_CTL: 0x00000000
       AUD_PINW_CNTR: 0x00000000
         AUD_CNTL_ST: 0x00000000
         AUD_PIN_CAP: 0x00000000
        AUD_PINW_CAP: 0x00000000
  AUD_PINW_UNSOLRESP: 0x00000000
    AUD_OUT_DIG_CNVT: 0x00000000
       AUD_OUT_CWCAP: 0x00000000
         AUD_GRP_CAP: 0x00000000
            FENCE  0: 0x00c00231 (enabled, X tiled, 4096 pitch,
0x00c00000 - 0x01000000 (4096kb))
            FENCE  1: 0x01000231 (enabled, X tiled, 4096 pitch,
0x01000000 - 0x01400000 (4096kb))
            FENCE  2: 0x00000000 (disabled)
            FENCE  3: 0x00000000 (disabled)
            FENCE  4: 0x00000000 (disabled)
            FENCE  5: 0x00000000 (disabled)
            FENCE  6: 0x00000000 (disabled)
            FENCE  7: 0x00000000 (disabled)
            FENCE  8: 0x00000000 (disabled)
            FENCE  9: 0x00000000 (disabled)
           FENCE  10: 0x00000000 (disabled)
           FENCE  11: 0x00000000 (disabled)
           FENCE  12: 0x00000000 (disabled)
           FENCE  13: 0x00000000 (disabled)
           FENCE  14: 0x00000000 (disabled)
           FENCE  15: 0x00000000 (disabled)
             INST_PM: 0x00000000
pipe A dot 25173 n 5 m1 0 m2 116 p1 9 p2 10
pipe B dot 64914 n 5 m1 0 m2 140 p1 3 p2 14

And here for a non-busticated kernel:

[jcm@constitution ~]$ cat intel_regs_works.txt 
                 DCC: 0x00200020 (single channel, XOR randomization:
enabled, XOR bit: 11)
           CHDECMISC: 0x42000064 (XOR bank, ch2 enh disabled, ch1 enh
disabled, ch0 enh enabled, flex disabled, ep not present)
              C0DRB0: 0x00200020 (0x0020)
              C0DRB1: 0x00200020 (0x0020)
              C0DRB2: 0x00200020 (0x0020)
              C0DRB3: 0x00880020 (0x0020)
              C1DRB0: 0x00000000 (0x0000)
              C1DRB1: 0x00000000 (0x0000)
              C1DRB2: 0x00000000 (0x0000)
              C1DRB3: 0x00000000 (0x0000)
             C0DRA01: 0x00000088 (0x0088)
             C0DRA23: 0x00000000 (0x0000)
             C1DRA01: 0x00000000 (0x0000)
             C1DRA23: 0x00000000 (0x0000)
          PGETBL_CTL: 0x00000001
   VCLK_DIVISOR_VGA0: 0x00200074 (n = 32, m1 = 0, m2 = 52)
   VCLK_DIVISOR_VGA1: 0x00200074 (n = 32, m1 = 0, m2 = 52)
       VCLK_POST_DIV: 0x00800100 (vga0 p1 = 2, p2 = 2, vga1 p1 = 3, p2 =
2)
           DPLL_TEST: 0x00010001 ()
        CACHE_MODE_0: 0x00006820
             D_STATE: 0x0000000b
       DSPCLK_GATE_D: 0x00000000 (clock gates disabled:)
      RENCLK_GATE_D1: 0x00000000
      RENCLK_GATE_D2: 0x00000000
               SDVOB: 0x00300000 (disabled, pipe A, stall disabled, not
detected)
               SDVOC: 0x00300000 (disabled, pipe A, stall disabled, not
detected)
             SDVOUDI: 0x00000000
              DSPARB: 0x00001d9c
              DSPFW1: 0xf1830f0f
              DSPFW2: 0x0000030f
              DSPFW3: 0x6700018f
                ADPA: 0x40008c18 (disabled, pipe B, +hsync, +vsync)
                LVDS: 0xc0300300 (enabled, pipe B, 18 bit, 1 channel)
                DVOA: 0x00000000 (disabled, pipe A, no stall, -hsync,
-vsync)
                DVOB: 0x00300000 (disabled, pipe A, no stall, -hsync,
-vsync)
                DVOC: 0x00300000 (disabled, pipe A, no stall, -hsync,
-vsync)
         DVOA_SRCDIM: 0x00000000
         DVOB_SRCDIM: 0x00000000
         DVOC_SRCDIM: 0x00000000
          PP_CONTROL: 0x00000001 (power target: on)
           PP_STATUS: 0xc0000008 (on, ready, sequencing idle)
        PP_ON_DELAYS: 0x025807d0
       PP_OFF_DELAYS: 0x01f407d0
          PP_DIVISOR: 0x00209d05
        PFIT_CONTROL: 0x00000008
     PFIT_PGM_RATIOS: 0x00000000
     PORT_HOTPLUG_EN: 0x00000220
   PORT_HOTPLUG_STAT: 0x00001000
            DSPACNTR: 0xd9000000 (enabled, pipe B)
          DSPASTRIDE: 0x00001000 (4096 bytes)
             DSPAPOS: 0x00000000 (0, 0)
            DSPASIZE: 0x025703ff (1024, 600)
            DSPABASE: 0x00830000
            DSPASURF: 0x00000000
         DSPATILEOFF: 0x00000000
           PIPEACONF: 0x00000000 (disabled, single-wide)
            PIPEASRC: 0x027f01df (640, 480)
           PIPEASTAT: 0x00000000 (status:)
   PIPEA_GMCH_DATA_M: 0x00000000
   PIPEA_GMCH_DATA_N: 0x00000000
     PIPEA_DP_LINK_M: 0x00000000
     PIPEA_DP_LINK_N: 0x00000000
       CURSOR_A_BASE: 0x00000000
    CURSOR_A_CONTROL: 0x00000000
   CURSOR_A_POSITION: 0x00000000
                FPA0: 0x00200074 (n = 32, m1 = 0, m2 = 52)
                FPA1: 0x00200074 (n = 32, m1 = 0, m2 = 52)
              DPLL_A: 0x04800000 (disabled, non-dvo, VGA, default clock,
DAC/serial mode, p1 = 9, p2 = 10, SDVO mult 1)
           DPLL_A_MD: 0x00000000
            HTOTAL_A: 0x031f027f (640 active, 800 total)
            HBLANK_A: 0x03170287 (648 start, 792 end)
             HSYNC_A: 0x02ef028f (656 start, 752 end)
            VTOTAL_A: 0x020c01df (480 active, 525 total)
            VBLANK_A: 0x020401e7 (488 start, 517 end)
             VSYNC_A: 0x01eb01e9 (490 start, 492 end)
           BCLRPAT_A: 0x00000000
        VSYNCSHIFT_A: 0x00000000
            DSPBCNTR: 0x49000000 (disabled, pipe B)
          DSPBSTRIDE: 0x00000280 (640 bytes)
             DSPBPOS: 0x00000000 (0, 0)
            DSPBSIZE: 0x018f02cf (720, 400)
            DSPBBASE: 0x00000000
            DSPBSURF: 0x00000000
         DSPBTILEOFF: 0x00000000
           PIPEBCONF: 0x80000000 (enabled, single-wide)
            PIPEBSRC: 0x03ff0257 (1024, 600)
           PIPEBSTAT: 0x00400202 (status: LBLC_EVENT_ENABLE
VSYNC_INT_STATUS VBLANK_INT_STATUS)
   PIPEB_GMCH_DATA_M: 0x00000000
   PIPEB_GMCH_DATA_N: 0x00000000
     PIPEB_DP_LINK_M: 0x00000000
     PIPEB_DP_LINK_N: 0x00000000
       CURSOR_B_BASE: 0x00000000
    CURSOR_B_CONTROL: 0x10000000
   CURSOR_B_POSITION: 0x012801f9
                FPB0: 0x00100067 (n = 16, m1 = 0, m2 = 39)
                FPB1: 0x00100067 (n = 16, m1 = 0, m2 = 39)
              DPLL_B: 0x98040000 (enabled, non-dvo, default clock, LVDS
mode, p1 = 4, p2 = 14, SDVO mult 1)
           DPLL_B_MD: 0x00000000
            HTOTAL_B: 0x04af03ff (1024 active, 1200 total)
            HBLANK_B: 0x04af03ff (1024 start, 1200 end)
             HSYNC_B: 0x04570434 (1077 start, 1112 end)
            VTOTAL_B: 0x02700257 (600 active, 625 total)
            VBLANK_B: 0x02700257 (600 start, 625 end)
             VSYNC_B: 0x0260025b (604 start, 609 end)
           BCLRPAT_B: 0x00000000
        VSYNCSHIFT_B: 0x00000000
   VCLK_DIVISOR_VGA0: 0x00200074
   VCLK_DIVISOR_VGA1: 0x00200074
       VCLK_POST_DIV: 0x00800100
            VGACNTRL: 0x80000000 (disabled)
              TV_CTL: 0x00000000
              TV_DAC: 0x00000000
            TV_CSC_Y: 0x00000000
           TV_CSC_Y2: 0x00000000
            TV_CSC_U: 0x00000000
           TV_CSC_U2: 0x00000000
            TV_CSC_V: 0x00000000
           TV_CSC_V2: 0x00000000
        TV_CLR_KNOBS: 0x00000000
        TV_CLR_LEVEL: 0x00000000
          TV_H_CTL_1: 0x00000000
          TV_H_CTL_2: 0x00000000
          TV_H_CTL_3: 0x00000000
          TV_V_CTL_1: 0x00000000
          TV_V_CTL_2: 0x00000000
          TV_V_CTL_3: 0x00000000
          TV_V_CTL_4: 0x00000000
          TV_V_CTL_5: 0x00000000
          TV_V_CTL_6: 0x00000000
          TV_V_CTL_7: 0x00000000
         TV_SC_CTL_1: 0x00000000
         TV_SC_CTL_2: 0x00000000
         TV_SC_CTL_3: 0x00000000
          TV_WIN_POS: 0x00000000
         TV_WIN_SIZE: 0x00000000
     TV_FILTER_CTL_1: 0x00000000
     TV_FILTER_CTL_2: 0x00000000
     TV_FILTER_CTL_3: 0x00000000
       TV_CC_CONTROL: 0x00000000
          TV_CC_DATA: 0x00000000
         TV_H_LUMA_0: 0x00000000
        TV_H_LUMA_59: 0x00000000
       TV_H_CHROMA_0: 0x00000000
      TV_H_CHROMA_59: 0x00000000
        FBC_CFB_BASE: 0xffffffff
         FBC_LL_BASE: 0xffffffff
         FBC_CONTROL: 0xffffffff
         FBC_COMMAND: 0xffffffff
          FBC_STATUS: 0xffffffff
        FBC_CONTROL2: 0xffffffff
       FBC_FENCE_OFF: 0xffffffff
         FBC_MOD_NUM: 0xffffffff
             MI_MODE: 0x00000200
        MI_ARB_STATE: 0x00000840
      MI_RDRET_STATE: 0x00000000
             ECOSKPD: 0x00000307
                DP_B: 0x00000000
      DPB_AUX_CH_CTL: 0x00000000
    DPB_AUX_CH_DATA1: 0x00000000
    DPB_AUX_CH_DATA2: 0x00000000
    DPB_AUX_CH_DATA3: 0x00000000
    DPB_AUX_CH_DATA4: 0x00000000
    DPB_AUX_CH_DATA5: 0x00000000
                DP_C: 0x00000000
      DPC_AUX_CH_CTL: 0x00000000
    DPC_AUX_CH_DATA1: 0x00000000
    DPC_AUX_CH_DATA2: 0x00000000
    DPC_AUX_CH_DATA3: 0x00000000
    DPC_AUX_CH_DATA4: 0x00000000
    DPC_AUX_CH_DATA5: 0x00000000
                DP_D: 0x00000000
      DPD_AUX_CH_CTL: 0x00000000
    DPD_AUX_CH_DATA1: 0x00000000
    DPD_AUX_CH_DATA2: 0x00000000
    DPD_AUX_CH_DATA3: 0x00000000
    DPD_AUX_CH_DATA4: 0x00000000
    DPD_AUX_CH_DATA5: 0x00000000
          AUD_CONFIG: 0x00000000
    AUD_HDMIW_STATUS: 0x00000000
      AUD_CONV_CHCNT: 0x00000000
       VIDEO_DIP_CTL: 0x00000000
       AUD_PINW_CNTR: 0x00000000
         AUD_CNTL_ST: 0x00000000
         AUD_PIN_CAP: 0x00000000
        AUD_PINW_CAP: 0x00000000
  AUD_PINW_UNSOLRESP: 0x00000000
    AUD_OUT_DIG_CNVT: 0x00000000
       AUD_OUT_CWCAP: 0x00000000
         AUD_GRP_CAP: 0x00000000
            FENCE  0: 0x00c00231 (enabled, X tiled, 4096 pitch,
0x00c00000 - 0x01000000 (4096kb))
            FENCE  1: 0x01000231 (enabled, X tiled, 4096 pitch,
0x01000000 - 0x01400000 (4096kb))
            FENCE  2: 0x01400231 (enabled, X tiled, 4096 pitch,
0x01400000 - 0x01800000 (4096kb))
            FENCE  3: 0x00000000 (disabled)
            FENCE  4: 0x00000000 (disabled)
            FENCE  5: 0x00000000 (disabled)
            FENCE  6: 0x00000000 (disabled)
            FENCE  7: 0x00000000 (disabled)
            FENCE  8: 0x00000000 (disabled)
            FENCE  9: 0x00000000 (disabled)
           FENCE  10: 0x00000000 (disabled)
           FENCE  11: 0x00000000 (disabled)
           FENCE  12: 0x00000000 (disabled)
           FENCE  13: 0x00000000 (disabled)
           FENCE  14: 0x00000000 (disabled)
           FENCE  15: 0x00000000 (disabled)
             INST_PM: 0x00000000
pipe A dot 25173 n 5 m1 0 m2 116 p1 9 p2 10
pipe B dot 45000 n 4 m1 0 m2 103 p1 4 p2 14

Here's the diff between the two:

[jcm@constitution ~]$ diff intel_regs_broken.txt intel_regs_works.txt 
33c33
<                 LVDS: 0xc0308300 (enabled, pipe B, 18 bit, 1 channel)
---
>                 LVDS: 0xc0300300 (enabled, pipe B, 18 bit, 1 channel)
95,97c95,97
<                 FPB0: 0x0020008c (n = 32, m1 = 0, m2 = 12)
<                 FPB1: 0x0020008c (n = 32, m1 = 0, m2 = 12)
<               DPLL_B: 0x98020000 (enabled, non-dvo, default clock,
LVDS mode, p1 = 3, p2 = 14, SDVO mult 1)
---
>                 FPB0: 0x00100067 (n = 16, m1 = 0, m2 = 39)
>                 FPB1: 0x00100067 (n = 16, m1 = 0, m2 = 39)
>               DPLL_B: 0x98040000 (enabled, non-dvo, default clock,
LVDS mode, p1 = 4, p2 = 14, SDVO mult 1)
99,104c99,104
<             HTOTAL_B: 0x053f03ff (1024 active, 1344 total)
<             HBLANK_B: 0x053f03ff (1024 start, 1344 end)
<              HSYNC_B: 0x049f0417 (1048 start, 1184 end)
<             VTOTAL_B: 0x03250257 (600 active, 806 total)
<             VBLANK_B: 0x02d102ab (684 start, 722 end)
<              VSYNC_B: 0x02c102bb (700 start, 706 end)
---
>             HTOTAL_B: 0x04af03ff (1024 active, 1200 total)
>             HBLANK_B: 0x04af03ff (1024 start, 1200 end)
>              HSYNC_B: 0x04570434 (1077 start, 1112 end)
>             VTOTAL_B: 0x02700257 (600 active, 625 total)
>             VBLANK_B: 0x02700257 (600 start, 625 end)
>              VSYNC_B: 0x0260025b (604 start, 609 end)
192c192
<             FENCE  2: 0x00000000 (disabled)
---
>             FENCE  2: 0x01400231 (enabled, X tiled, 4096 pitch,
0x01400000 - 0x01800000 (4096kb))
208c208
< pipe B dot 64914 n 5 m1 0 m2 140 p1 3 p2 14
---
> pipe B dot 45000 n 4 m1 0 m2 103 p1 4 p2 14

Jon.



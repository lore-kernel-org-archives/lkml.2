Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab0KSWUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:20:14 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:59208 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570Ab0KSV64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:56 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: thomas@winischhofer.net, aaro.koskinen@iki.fi
Subject: [PATCH 3/9] sisfb: delete dead SIS_XORG_XF86 code
Date: Fri, 19 Nov 2010 23:58:45 +0200
Message-Id: <1290203931-25188-4-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
References: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete code for compiling the driver for X.org/XFree86. The development
has forked, so there is no point keeping this code in the tree.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/init.c     |  537 ------------------------------------------
 drivers/video/sis/init.h     |   40 ---
 drivers/video/sis/init301.c  |  162 -------------
 drivers/video/sis/init301.h  |   14 -
 drivers/video/sis/osdef.h    |   20 --
 drivers/video/sis/vgatypes.h |    9 -
 drivers/video/sis/vstruct.h  |    6 -
 7 files changed, 0 insertions(+), 788 deletions(-)

diff --git a/drivers/video/sis/init.c b/drivers/video/sis/init.c
index c311ad3..53e30ea 100644
--- a/drivers/video/sis/init.c
+++ b/drivers/video/sis/init.c
@@ -340,9 +340,7 @@ SiSInitPtr(struct SiS_Private *SiS_Pr)
 /*            HELPER: Get ModeID             */
 /*********************************************/
 
-#ifndef SIS_XORG_XF86
 static
-#endif
 unsigned short
 SiS_GetModeID(int VGAEngine, unsigned int VBFlags, int HDisplay, int VDisplay,
 		int Depth, bool FSTN, int LCDwidth, int LCDheight)
@@ -2999,11 +2997,6 @@ SiS_SetCRT1Group(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned sho
    SiS_Pr->SiS_SelectCRT2Rate = 0;
    SiS_Pr->SiS_SetFlag &= (~ProgrammingCRT2);
 
-#ifdef SIS_XORG_XF86
-   xf86DrvMsgVerb(0, X_PROBED, 4, "(init: VBType=0x%04x, VBInfo=0x%04x)\n",
-                    SiS_Pr->SiS_VBType, SiS_Pr->SiS_VBInfo);
-#endif
-
    if(SiS_Pr->SiS_VBInfo & SetSimuScanMode) {
       if(SiS_Pr->SiS_VBInfo & SetInSlaveMode) {
          SiS_Pr->SiS_SetFlag |= ProgrammingCRT2;
@@ -3203,73 +3196,11 @@ SiS_Handle760(struct SiS_Private *SiS_Pr)
 }
 
 /*********************************************/
-/*      X.org/XFree86: SET SCREEN PITCH      */
-/*********************************************/
-
-#ifdef SIS_XORG_XF86
-static void
-SiS_SetPitchCRT1(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn)
-{
-   SISPtr pSiS = SISPTR(pScrn);
-   unsigned short HDisplay = pSiS->scrnPitch >> 3;
-
-   SiS_SetReg(SiS_Pr->SiS_P3d4,0x13,(HDisplay & 0xFF));
-   SiS_SetRegANDOR(SiS_Pr->SiS_P3c4,0x0E,0xF0,(HDisplay >> 8));
-}
-
-static void
-SiS_SetPitchCRT2(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn)
-{
-   SISPtr pSiS = SISPTR(pScrn);
-   unsigned short HDisplay = pSiS->scrnPitch2 >> 3;
-
-    /* Unlock CRT2 */
-   if(pSiS->VGAEngine == SIS_315_VGA)
-      SiS_SetRegOR(SiS_Pr->SiS_Part1Port,0x2F, 0x01);
-   else
-      SiS_SetRegOR(SiS_Pr->SiS_Part1Port,0x24, 0x01);
-
-   SiS_SetReg(SiS_Pr->SiS_Part1Port,0x07,(HDisplay & 0xFF));
-   SiS_SetRegANDOR(SiS_Pr->SiS_Part1Port,0x09,0xF0,(HDisplay >> 8));
-}
-
-static void
-SiS_SetPitch(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn)
-{
-   SISPtr pSiS = SISPTR(pScrn);
-   bool isslavemode = false;
-
-   if( (pSiS->VBFlags2 & VB2_VIDEOBRIDGE) &&
-       ( ((pSiS->VGAEngine == SIS_300_VGA) &&
-	  (SiS_GetReg(SiS_Pr->SiS_Part1Port,0x00) & 0xa0) == 0x20) ||
-	 ((pSiS->VGAEngine == SIS_315_VGA) &&
-	  (SiS_GetReg(SiS_Pr->SiS_Part1Port,0x00) & 0x50) == 0x10) ) ) {
-      isslavemode = true;
-   }
-
-   /* We need to set pitch for CRT1 if bridge is in slave mode, too */
-   if((pSiS->VBFlags & DISPTYPE_DISP1) || (isslavemode)) {
-      SiS_SetPitchCRT1(SiS_Pr, pScrn);
-   }
-   /* We must not set the pitch for CRT2 if bridge is in slave mode */
-   if((pSiS->VBFlags & DISPTYPE_DISP2) && (!isslavemode)) {
-      SiS_SetPitchCRT2(SiS_Pr, pScrn);
-   }
-}
-#endif
-
-/*********************************************/
 /*                 SiSSetMode()              */
 /*********************************************/
 
-#ifdef SIS_XORG_XF86
-/* We need pScrn for setting the pitch correctly */
-bool
-SiSSetMode(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn, unsigned short ModeNo, bool dosetpitch)
-#else
 bool
 SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
-#endif
 {
    SISIOADDRESS BaseAddr = SiS_Pr->IOAddress;
    unsigned short RealModeNo, ModeIdIndex;
@@ -3301,9 +3232,6 @@ SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
    SiS_GetSysFlags(SiS_Pr);
 
    SiS_Pr->SiS_VGAINFO = 0x11;
-#if defined(SIS_XORG_XF86) && (defined(i386) || defined(__i386) || defined(__i386__) || defined(__AMD64__) || defined(__amd64__) || defined(__x86_64__))
-   if(pScrn) SiS_Pr->SiS_VGAINFO = SiS_GetSetBIOSScratch(pScrn, 0x489, 0xff);
-#endif
 
 #ifdef SIS_LINUX_KERNEL
    KeepLockReg = SiS_GetReg(SiS_Pr->SiS_P3c4,0x05);
@@ -3424,18 +3352,6 @@ SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
       }
    }
 
-#ifdef SIS_XORG_XF86
-   if(pScrn) {
-      /* SetPitch: Adapt to virtual size & position */
-      if((ModeNo > 0x13) && (dosetpitch)) {
-	 SiS_SetPitch(SiS_Pr, pScrn);
-      }
-
-      /* Backup/Set ModeNo in BIOS scratch area */
-      SiS_GetSetModeID(pScrn, ModeNo);
-   }
-#endif
-
    SiS_CloseCRTC(SiS_Pr);
 
    SiS_Handle760(SiS_Pr);
@@ -3448,400 +3364,6 @@ SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
    return true;
 }
 
-/*********************************************/
-/*       X.org/XFree86: SiSBIOSSetMode()     */
-/*           for non-Dual-Head mode          */
-/*********************************************/
-
-#ifdef SIS_XORG_XF86
-bool
-SiSBIOSSetMode(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn,
-               DisplayModePtr mode, bool IsCustom)
-{
-   SISPtr pSiS = SISPTR(pScrn);
-   unsigned short ModeNo = 0;
-
-   SiS_Pr->UseCustomMode = false;
-
-   if((IsCustom) && (SiS_CheckBuildCustomMode(pScrn, mode, pSiS->VBFlags))) {
-
-      xf86DrvMsgVerb(pScrn->scrnIndex, X_INFO, 3, "Setting custom mode %dx%d\n",
-		SiS_Pr->CHDisplay,
-		(mode->Flags & V_INTERLACE ? SiS_Pr->CVDisplay * 2 :
-		   (mode->Flags & V_DBLSCAN ? SiS_Pr->CVDisplay / 2 :
-		      SiS_Pr->CVDisplay)));
-
-   } else {
-
-      /* Don't need vbflags here; checks done earlier */
-      ModeNo = SiS_GetModeNumber(pScrn, mode, pSiS->VBFlags);
-      if(!ModeNo) return false;
-
-      xf86DrvMsgVerb(pScrn->scrnIndex, X_INFO, 3, "Setting standard mode 0x%x\n", ModeNo);
-
-   }
-
-   return(SiSSetMode(SiS_Pr, pScrn, ModeNo, true));
-}
-
-/*********************************************/
-/*    X.org/XFree86: SiSBIOSSetModeCRT2()    */
-/*           for Dual-Head modes             */
-/*********************************************/
-
-bool
-SiSBIOSSetModeCRT2(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn,
-               DisplayModePtr mode, bool IsCustom)
-{
-   SISIOADDRESS BaseAddr = SiS_Pr->IOAddress;
-   SISPtr  pSiS = SISPTR(pScrn);
-#ifdef SISDUALHEAD
-   SISEntPtr pSiSEnt = pSiS->entityPrivate;
-#endif
-   unsigned short ModeIdIndex;
-   unsigned short ModeNo = 0;
-   unsigned char  backupreg = 0;
-
-   SiS_Pr->UseCustomMode = false;
-
-   /* Remember: Custom modes for CRT2 are ONLY supported
-    *     -) on the 30x/B/C, and
-    *     -) if CRT2 is LCD or VGA, or CRT1 is LCDA
-    */
-
-   if((IsCustom) && (SiS_CheckBuildCustomMode(pScrn, mode, pSiS->VBFlags))) {
-
-	 ModeNo = 0xfe;
-
-   } else {
-
-	 ModeNo = SiS_GetModeNumber(pScrn, mode, pSiS->VBFlags);
-	 if(!ModeNo) return false;
-
-   }
-
-   SiSRegInit(SiS_Pr, BaseAddr);
-   SiSInitPtr(SiS_Pr);
-   SiS_GetSysFlags(SiS_Pr);
-#if defined(i386) || defined(__i386) || defined(__i386__) || defined(__AMD64__) || defined(__amd64__) || defined(__x86_64__)
-   SiS_Pr->SiS_VGAINFO = SiS_GetSetBIOSScratch(pScrn, 0x489, 0xff);
-#else
-   SiS_Pr->SiS_VGAINFO = 0x11;
-#endif
-
-   SiS_SetReg(SiS_Pr->SiS_P3c4,0x05,0x86);
-
-   SiSInitPCIetc(SiS_Pr);
-   SiSSetLVDSetc(SiS_Pr);
-   SiSDetermineROMUsage(SiS_Pr);
-
-   /* Save mode info so we can set it from within SetMode for CRT1 */
-#ifdef SISDUALHEAD
-   if(pSiS->DualHeadMode) {
-      pSiSEnt->CRT2ModeNo = ModeNo;
-      pSiSEnt->CRT2DMode = mode;
-      pSiSEnt->CRT2IsCustom = IsCustom;
-      pSiSEnt->CRT2CR30 = SiS_GetReg(SiS_Pr->SiS_P3d4,0x30);
-      pSiSEnt->CRT2CR31 = SiS_GetReg(SiS_Pr->SiS_P3d4,0x31);
-      pSiSEnt->CRT2CR35 = SiS_GetReg(SiS_Pr->SiS_P3d4,0x35);
-      pSiSEnt->CRT2CR38 = SiS_GetReg(SiS_Pr->SiS_P3d4,0x38);
-#if 0
-      /* We can't set CRT2 mode before CRT1 mode is set - says who...? */
-      if(pSiSEnt->CRT1ModeNo == -1) {
-	 xf86DrvMsgVerb(pScrn->scrnIndex, X_INFO, 3,
-		"Setting CRT2 mode delayed until after setting CRT1 mode\n");
-	 return true;
-      }
-#endif
-      pSiSEnt->CRT2ModeSet = true;
-   }
-#endif
-
-   if(SiS_Pr->UseCustomMode) {
-
-      unsigned short temptemp = SiS_Pr->CVDisplay;
-
-      if(SiS_Pr->CModeFlag & DoubleScanMode)     temptemp >>= 1;
-      else if(SiS_Pr->CInfoFlag & InterlaceMode) temptemp <<= 1;
-
-      xf86DrvMsgVerb(pScrn->scrnIndex, X_INFO, 3,
-	  "Setting custom mode %dx%d on CRT2\n",
-	  SiS_Pr->CHDisplay, temptemp);
-
-   } else {
-
-      xf86DrvMsgVerb(pScrn->scrnIndex, X_INFO, 3,
-	  "Setting standard mode 0x%x on CRT2\n", ModeNo);
-
-   }
-
-   SiS_UnLockCRT2(SiS_Pr);
-
-   if(!SiS_Pr->UseCustomMode) {
-      if(!(SiS_SearchModeID(SiS_Pr, &ModeNo, &ModeIdIndex))) return false;
-   } else {
-      ModeIdIndex = 0;
-   }
-
-   SiS_GetVBType(SiS_Pr);
-
-   SiS_InitVB(SiS_Pr);
-   if(SiS_Pr->SiS_VBType & VB_SIS30xBLV) {
-      if(SiS_Pr->ChipType >= SIS_315H) {
-	 SiS_ResetVB(SiS_Pr);
-	 SiS_SetRegOR(SiS_Pr->SiS_P3c4,0x32,0x10);
-	 SiS_SetRegOR(SiS_Pr->SiS_Part2Port,0x00,0x0c);
-	 backupreg = SiS_GetReg(SiS_Pr->SiS_P3d4,0x38);
-      } else {
-	 backupreg = SiS_GetReg(SiS_Pr->SiS_P3d4,0x35);
-      }
-   }
-
-   /* Get VB information (connectors, connected devices) */
-   if(!SiS_Pr->UseCustomMode) {
-      SiS_GetVBInfo(SiS_Pr, ModeNo, ModeIdIndex, 1);
-   } else {
-      /* If this is a custom mode, we don't check the modeflag for CRT2Mode */
-      SiS_GetVBInfo(SiS_Pr, ModeNo, ModeIdIndex, 0);
-   }
-   SiS_SetYPbPr(SiS_Pr);
-   SiS_SetTVMode(SiS_Pr, ModeNo, ModeIdIndex);
-   SiS_GetLCDResInfo(SiS_Pr, ModeNo, ModeIdIndex);
-   SiS_SetLowModeTest(SiS_Pr, ModeNo);
-
-   SiS_ResetSegmentRegisters(SiS_Pr);
-
-   /* Set mode on CRT2 */
-   if( (SiS_Pr->SiS_VBType & VB_SISVB)    ||
-       (SiS_Pr->SiS_IF_DEF_LVDS     == 1) ||
-       (SiS_Pr->SiS_IF_DEF_CH70xx   != 0) ||
-       (SiS_Pr->SiS_IF_DEF_TRUMPION != 0) ) {
-      SiS_SetCRT2Group(SiS_Pr, ModeNo);
-   }
-
-   SiS_StrangeStuff(SiS_Pr);
-
-   SiS_DisplayOn(SiS_Pr);
-   SiS_SetRegByte(SiS_Pr->SiS_P3c6,0xFF);
-
-   if(SiS_Pr->ChipType >= SIS_315H) {
-      if(SiS_Pr->SiS_IF_DEF_LVDS == 1) {
-	 if(!(SiS_IsDualEdge(SiS_Pr))) {
-	    SiS_SetRegAND(SiS_Pr->SiS_Part1Port,0x13,0xfb);
-	 }
-      }
-   }
-
-   if(SiS_Pr->SiS_VBType & VB_SIS30xBLV) {
-      if(SiS_Pr->ChipType >= SIS_315H) {
-	 if(!SiS_Pr->SiS_ROMNew) {
-	    if(SiS_IsVAMode(SiS_Pr)) {
-	       SiS_SetRegOR(SiS_Pr->SiS_P3d4,0x35,0x01);
-	    } else {
-	       SiS_SetRegAND(SiS_Pr->SiS_P3d4,0x35,0xFE);
-	    }
-	 }
-
-	 SiS_SetReg(SiS_Pr->SiS_P3d4,0x38,backupreg);
-
-	 if(SiS_GetReg(SiS_Pr->SiS_P3d4,0x30) & SetCRT2ToLCD) {
-	    SiS_SetRegAND(SiS_Pr->SiS_P3d4,0x38,0xfc);
-	 }
-      } else if((SiS_Pr->ChipType == SIS_630) ||
-	        (SiS_Pr->ChipType == SIS_730)) {
-         SiS_SetReg(SiS_Pr->SiS_P3d4,0x35,backupreg);
-      }
-   }
-
-   /* SetPitch: Adapt to virtual size & position */
-   SiS_SetPitchCRT2(SiS_Pr, pScrn);
-
-   SiS_Handle760(SiS_Pr);
-
-   return true;
-}
-
-/*********************************************/
-/*    X.org/XFree86: SiSBIOSSetModeCRT1()    */
-/*           for Dual-Head modes             */
-/*********************************************/
-
-bool
-SiSBIOSSetModeCRT1(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn,
-                   DisplayModePtr mode, bool IsCustom)
-{
-   SISIOADDRESS BaseAddr = SiS_Pr->IOAddress;
-   SISPtr  pSiS = SISPTR(pScrn);
-   unsigned short ModeIdIndex, ModeNo = 0;
-   unsigned char  backupreg = 0;
-#ifdef SISDUALHEAD
-   SISEntPtr pSiSEnt = pSiS->entityPrivate;
-   unsigned char  backupcr30, backupcr31, backupcr38, backupcr35, backupp40d=0;
-   bool backupcustom;
-#endif
-
-   SiS_Pr->UseCustomMode = false;
-
-   if((IsCustom) && (SiS_CheckBuildCustomMode(pScrn, mode, pSiS->VBFlags))) {
-
-	 unsigned short temptemp = SiS_Pr->CVDisplay;
-
-	 if(SiS_Pr->CModeFlag & DoubleScanMode)     temptemp >>= 1;
-	 else if(SiS_Pr->CInfoFlag & InterlaceMode) temptemp <<= 1;
-
-	 xf86DrvMsgVerb(pScrn->scrnIndex, X_INFO, 3,
-	 	"Setting custom mode %dx%d on CRT1\n",
-	 	SiS_Pr->CHDisplay, temptemp);
-	 ModeNo = 0xfe;
-
-   } else {
-
-	 ModeNo = SiS_GetModeNumber(pScrn, mode, 0); /* don't give VBFlags */
-	 if(!ModeNo) return false;
-
-	 xf86DrvMsgVerb(pScrn->scrnIndex, X_INFO, 3,
-	 	"Setting standard mode 0x%x on CRT1\n", ModeNo);
-   }
-
-   SiSInitPtr(SiS_Pr);
-   SiSRegInit(SiS_Pr, BaseAddr);
-   SiS_GetSysFlags(SiS_Pr);
-#if defined(i386) || defined(__i386) || defined(__i386__) || defined(__AMD64__) || defined(__amd64__) || defined(__x86_64__)
-   SiS_Pr->SiS_VGAINFO = SiS_GetSetBIOSScratch(pScrn, 0x489, 0xff);
-#else
-   SiS_Pr->SiS_VGAINFO = 0x11;
-#endif
-
-   SiS_SetReg(SiS_Pr->SiS_P3c4,0x05,0x86);
-
-   SiSInitPCIetc(SiS_Pr);
-   SiSSetLVDSetc(SiS_Pr);
-   SiSDetermineROMUsage(SiS_Pr);
-
-   SiS_UnLockCRT2(SiS_Pr);
-
-   if(!SiS_Pr->UseCustomMode) {
-      if(!(SiS_SearchModeID(SiS_Pr, &ModeNo, &ModeIdIndex))) return false;
-   } else {
-      ModeIdIndex = 0;
-   }
-
-   /* Determine VBType */
-   SiS_GetVBType(SiS_Pr);
-
-   SiS_InitVB(SiS_Pr);
-   if(SiS_Pr->SiS_VBType & VB_SIS30xBLV) {
-      if(SiS_Pr->ChipType >= SIS_315H) {
-         backupreg = SiS_GetReg(SiS_Pr->SiS_P3d4,0x38);
-      } else {
-         backupreg = SiS_GetReg(SiS_Pr->SiS_P3d4,0x35);
-      }
-   }
-
-   /* Get VB information (connectors, connected devices) */
-   /* (We don't care if the current mode is a CRT2 mode) */
-   SiS_GetVBInfo(SiS_Pr, ModeNo, ModeIdIndex, 0);
-   SiS_SetYPbPr(SiS_Pr);
-   SiS_SetTVMode(SiS_Pr, ModeNo, ModeIdIndex);
-   SiS_GetLCDResInfo(SiS_Pr, ModeNo, ModeIdIndex);
-   SiS_SetLowModeTest(SiS_Pr, ModeNo);
-
-   SiS_OpenCRTC(SiS_Pr);
-
-   /* Set mode on CRT1 */
-   SiS_SetCRT1Group(SiS_Pr, ModeNo, ModeIdIndex);
-   if(SiS_Pr->SiS_VBInfo & SetCRT2ToLCDA) {
-      SiS_SetCRT2Group(SiS_Pr, ModeNo);
-   }
-
-   /* SetPitch: Adapt to virtual size & position */
-   SiS_SetPitchCRT1(SiS_Pr, pScrn);
-
-   SiS_HandleCRT1(SiS_Pr);
-
-   SiS_StrangeStuff(SiS_Pr);
-
-   SiS_CloseCRTC(SiS_Pr);
-
-#ifdef SISDUALHEAD
-   if(pSiS->DualHeadMode) {
-      pSiSEnt->CRT1ModeNo = ModeNo;
-      pSiSEnt->CRT1DMode = mode;
-   }
-#endif
-
-   if(SiS_Pr->UseCustomMode) {
-      SiS_Pr->CRT1UsesCustomMode = true;
-      SiS_Pr->CSRClock_CRT1 = SiS_Pr->CSRClock;
-      SiS_Pr->CModeFlag_CRT1 = SiS_Pr->CModeFlag;
-   } else {
-      SiS_Pr->CRT1UsesCustomMode = false;
-   }
-
-   /* Reset CRT2 if changing mode on CRT1 */
-#ifdef SISDUALHEAD
-   if(pSiS->DualHeadMode) {
-      if(pSiSEnt->CRT2ModeNo != -1) {
-	 xf86DrvMsgVerb(pScrn->scrnIndex, X_INFO, 3,
-				"(Re-)Setting mode for CRT2\n");
-	 backupcustom = SiS_Pr->UseCustomMode;
-	 backupcr30 = SiS_GetReg(SiS_Pr->SiS_P3d4,0x30);
-	 backupcr31 = SiS_GetReg(SiS_Pr->SiS_P3d4,0x31);
-	 backupcr35 = SiS_GetReg(SiS_Pr->SiS_P3d4,0x35);
-	 backupcr38 = SiS_GetReg(SiS_Pr->SiS_P3d4,0x38);
-	 if(SiS_Pr->SiS_VBType & VB_SISVB) {
-	    /* Backup LUT-enable */
-	    if(pSiSEnt->CRT2ModeSet) {
-	       backupp40d = SiS_GetReg(SiS_Pr->SiS_Part4Port,0x0d) & 0x08;
-	    }
-	 }
-	 if(SiS_Pr->SiS_VBInfo & SetCRT2ToLCDA) {
-	    SiS_SetReg(SiS_Pr->SiS_P3d4,0x30,pSiSEnt->CRT2CR30);
-	    SiS_SetReg(SiS_Pr->SiS_P3d4,0x31,pSiSEnt->CRT2CR31);
-	    SiS_SetReg(SiS_Pr->SiS_P3d4,0x35,pSiSEnt->CRT2CR35);
-	    SiS_SetReg(SiS_Pr->SiS_P3d4,0x38,pSiSEnt->CRT2CR38);
-	 }
-
-	 SiSBIOSSetModeCRT2(SiS_Pr, pSiSEnt->pScrn_1,
-			    pSiSEnt->CRT2DMode, pSiSEnt->CRT2IsCustom);
-
-	 SiS_SetReg(SiS_Pr->SiS_P3d4,0x30,backupcr30);
-	 SiS_SetReg(SiS_Pr->SiS_P3d4,0x31,backupcr31);
-	 SiS_SetReg(SiS_Pr->SiS_P3d4,0x35,backupcr35);
-	 SiS_SetReg(SiS_Pr->SiS_P3d4,0x38,backupcr38);
-	 if(SiS_Pr->SiS_VBType & VB_SISVB) {
-	    SiS_SetRegANDOR(SiS_Pr->SiS_Part4Port,0x0d, ~0x08, backupp40d);
-	 }
-	 SiS_Pr->UseCustomMode = backupcustom;
-      }
-   }
-#endif
-
-   /* Warning: From here, the custom mode entries in SiS_Pr are
-    * possibly overwritten
-    */
-
-   SiS_DisplayOn(SiS_Pr);
-   SiS_SetRegByte(SiS_Pr->SiS_P3c6,0xFF);
-
-   if(SiS_Pr->SiS_VBType & VB_SIS30xBLV) {
-      if(SiS_Pr->ChipType >= SIS_315H) {
-	 SiS_SetReg(SiS_Pr->SiS_P3d4,0x38,backupreg);
-      } else if((SiS_Pr->ChipType == SIS_630) ||
-                (SiS_Pr->ChipType == SIS_730)) {
-         SiS_SetReg(SiS_Pr->SiS_P3d4,0x35,backupreg);
-      }
-   }
-
-   SiS_Handle760(SiS_Pr);
-
-   /* Backup/Set ModeNo in BIOS scratch area */
-   SiS_GetSetModeID(pScrn,ModeNo);
-
-   return true;
-}
-#endif /* Linux_XF86 */
-
 #ifndef GETBITSTR
 #define BITMASK(h,l)    	(((unsigned)(1U << ((h)-(l)+1))-1)<<(l))
 #define GENMASK(mask)   	BITMASK(1?mask,0?mask)
@@ -4054,33 +3576,11 @@ SiS_CalcLCDACRT1Timing(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
    if(modeflag & DoubleScanMode) tempax |= 0x80;
    SiS_SetRegANDOR(SiS_Pr->SiS_P3d4,0x09,0x5F,tempax);
 
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-   xf86DrvMsg(0, X_INFO, "%d %d %d %d  %d %d %d %d  (%d %d %d %d)\n",
-	SiS_Pr->CHDisplay, SiS_Pr->CHSyncStart, SiS_Pr->CHSyncEnd, SiS_Pr->CHTotal,
-	SiS_Pr->CVDisplay, SiS_Pr->CVSyncStart, SiS_Pr->CVSyncEnd, SiS_Pr->CVTotal,
-	SiS_Pr->CHBlankStart, SiS_Pr->CHBlankEnd, SiS_Pr->CVBlankStart, SiS_Pr->CVBlankEnd);
-   xf86DrvMsg(0, X_INFO, " {{0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,\n",
-	SiS_Pr->CCRT1CRTC[0], SiS_Pr->CCRT1CRTC[1],
-	SiS_Pr->CCRT1CRTC[2], SiS_Pr->CCRT1CRTC[3],
-	SiS_Pr->CCRT1CRTC[4], SiS_Pr->CCRT1CRTC[5],
-	SiS_Pr->CCRT1CRTC[6], SiS_Pr->CCRT1CRTC[7]);
-   xf86DrvMsg(0, X_INFO, "   0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,\n",
-	SiS_Pr->CCRT1CRTC[8], SiS_Pr->CCRT1CRTC[9],
-	SiS_Pr->CCRT1CRTC[10], SiS_Pr->CCRT1CRTC[11],
-	SiS_Pr->CCRT1CRTC[12], SiS_Pr->CCRT1CRTC[13],
-	SiS_Pr->CCRT1CRTC[14], SiS_Pr->CCRT1CRTC[15]);
-   xf86DrvMsg(0, X_INFO, "   0x%02x}},\n", SiS_Pr->CCRT1CRTC[16]);
-#endif
-#endif
 }
 
 void
 SiS_Generic_ConvertCRData(struct SiS_Private *SiS_Pr, unsigned char *crdata,
 			int xres, int yres,
-#ifdef SIS_XORG_XF86
-			DisplayModePtr current
-#endif
 #ifdef SIS_LINUX_KERNEL
 			struct fb_var_screeninfo *var, bool writeres
 #endif
@@ -4127,19 +3627,6 @@ SiS_Generic_ConvertCRData(struct SiS_Private *SiS_Pr, unsigned char *crdata,
 
    D = B - F - C;
 
-#ifdef SIS_XORG_XF86
-   current->HDisplay   = (E * 8);
-   current->HSyncStart = (E * 8) + (F * 8);
-   current->HSyncEnd   = (E * 8) + (F * 8) + (C * 8);
-   current->HTotal     = (E * 8) + (F * 8) + (C * 8) + (D * 8);
-#ifdef TWDEBUG
-   xf86DrvMsg(0, X_INFO,
-		"H: A %d B %d C %d D %d E %d F %d  HT %d HDE %d HRS %d HBS %d HBE %d HRE %d\n",
-		A, B, C, D, E, F, HT, HDE, HRS, HBS, HBE, HRE);
-#else
-   (void)VBS;  (void)HBS;  (void)A;
-#endif
-#endif
 #ifdef SIS_LINUX_KERNEL
    if(writeres) var->xres = xres = E * 8;
    var->left_margin = D * 8;
@@ -4192,24 +3679,6 @@ SiS_Generic_ConvertCRData(struct SiS_Private *SiS_Pr, unsigned char *crdata,
 
    D = B - F - C;
 
-#ifdef SIS_XORG_XF86
-   current->VDisplay   = VDE + 1;
-   current->VSyncStart = VRS + 1;
-   current->VSyncEnd   = ((VRS & ~0x1f) | VRE) + 1;
-   if(VRE <= (VRS & 0x1f)) current->VSyncEnd += 32;
-   current->VTotal     = E + D + C + F;
-#if 0
-   current->VDisplay   = E;
-   current->VSyncStart = E + D;
-   current->VSyncEnd   = E + D + C;
-   current->VTotal     = E + D + C + F;
-#endif
-#ifdef TWDEBUG
-   xf86DrvMsg(0, X_INFO,
-	"V: A %d B %d C %d D %d E %d F %d  VT %d VDE %d VRS %d VBS %d VBE %d VRE %d\n",
-	A, B, C, D, E, F, VT, VDE, VRS, VBS, VBE, VRE);
-#endif
-#endif
 #ifdef SIS_LINUX_KERNEL
    if(writeres) var->yres = yres = E;
    var->upper_margin = D;
@@ -4224,12 +3693,6 @@ SiS_Generic_ConvertCRData(struct SiS_Private *SiS_Pr, unsigned char *crdata,
 	 * a negative D. The CRT controller does not
 	 * seem to like correcting HRE to 50)
 	 */
-#ifdef SIS_XORG_XF86
-      current->HDisplay   = 320;
-      current->HSyncStart = 328;
-      current->HSyncEnd   = 376;
-      current->HTotal     = 400;
-#endif
 #ifdef SIS_LINUX_KERNEL
       var->left_margin = (400 - 376);
       var->right_margin = (328 - 320);
diff --git a/drivers/video/sis/init.h b/drivers/video/sis/init.h
index b96005c..4a75c73 100644
--- a/drivers/video/sis/init.h
+++ b/drivers/video/sis/init.h
@@ -56,17 +56,6 @@
 #include "osdef.h"
 #include "initdef.h"
 
-#ifdef SIS_XORG_XF86
-#include "sis.h"
-#define SIS_NEED_inSISREG
-#define SIS_NEED_inSISREGW
-#define SIS_NEED_inSISREGL
-#define SIS_NEED_outSISREG
-#define SIS_NEED_outSISREGW
-#define SIS_NEED_outSISREGL
-#include "sis_regs.h"
-#endif
-
 #ifdef SIS_LINUX_KERNEL
 #include "vgatypes.h"
 #include "vstruct.h"
@@ -1521,10 +1510,6 @@ static const struct SiS_LVDSCRT1Data SiS_LVDSCRT1640x480_1_H[] =
 };
 
 bool		SiSInitPtr(struct SiS_Private *SiS_Pr);
-#ifdef SIS_XORG_XF86
-unsigned short	SiS_GetModeID(int VGAEngine, unsigned int VBFlags, int HDisplay, int VDisplay,
-				int Depth, bool FSTN, int LCDwith, int LCDheight);
-#endif
 unsigned short	SiS_GetModeID_LCD(int VGAEngine, unsigned int VBFlags, int HDisplay,
 				int VDisplay, int Depth, bool FSTN,
 				unsigned short CustomT, int LCDwith, int LCDheight,
@@ -1579,26 +1564,12 @@ unsigned short	SiS_GetFIFOThresholdB300(unsigned short idx1, unsigned short idx2
 unsigned short	SiS_GetLatencyFactor630(struct SiS_Private *SiS_Pr, unsigned short index);
 #endif
 void		SiS_LoadDAC(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short ModeIdIndex);
-#ifdef SIS_XORG_XF86
-bool		SiSSetMode(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn, unsigned short ModeNo,
-				bool dosetpitch);
-bool		SiSBIOSSetMode(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn,
-				DisplayModePtr mode, bool IsCustom);
-bool		SiSBIOSSetModeCRT2(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn,
-				DisplayModePtr mode, bool IsCustom);
-bool		SiSBIOSSetModeCRT1(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn,
-				DisplayModePtr mode, bool IsCustom);
-#endif
 #ifdef SIS_LINUX_KERNEL
 bool		SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo);
 #endif
 void		SiS_CalcCRRegisters(struct SiS_Private *SiS_Pr, int depth);
 void		SiS_CalcLCDACRT1Timing(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 				unsigned short ModeIdIndex);
-#ifdef SIS_XORG_XF86
-void		SiS_Generic_ConvertCRData(struct SiS_Private *SiS_Pr, unsigned char *crdata, int xres,
-				int yres, DisplayModePtr current);
-#endif
 #ifdef SIS_LINUX_KERNEL
 void		SiS_Generic_ConvertCRData(struct SiS_Private *SiS_Pr, unsigned char *crdata, int xres,
 				int yres, struct fb_var_screeninfo *var, bool writeres);
@@ -1626,17 +1597,6 @@ extern unsigned short	SiS_GetVCLK2Ptr(struct SiS_Private *SiS_Pr, unsigned short
 extern bool		SiS_IsVAMode(struct SiS_Private *);
 extern bool		SiS_IsDualEdge(struct SiS_Private *);
 
-#ifdef SIS_XORG_XF86
-/* From other modules: */
-extern unsigned short	SiS_CheckBuildCustomMode(ScrnInfoPtr pScrn, DisplayModePtr mode,
-				unsigned int VBFlags);
-extern unsigned char	SiS_GetSetBIOSScratch(ScrnInfoPtr pScrn, unsigned short offset,
-				unsigned char value);
-extern unsigned char	SiS_GetSetModeID(ScrnInfoPtr pScrn, unsigned char id);
-extern unsigned short 	SiS_GetModeNumber(ScrnInfoPtr pScrn, DisplayModePtr mode,
-				unsigned int VBFlags);
-#endif
-
 #ifdef SIS_LINUX_KERNEL
 #ifdef SIS300
 extern unsigned int	sisfb_read_nbridge_pci_dword(struct SiS_Private *SiS_Pr, int reg);
diff --git a/drivers/video/sis/init301.c b/drivers/video/sis/init301.c
index da33d80..a4b344e 100644
--- a/drivers/video/sis/init301.c
+++ b/drivers/video/sis/init301.c
@@ -1166,12 +1166,6 @@ SiS_GetVBInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
       SiS_Pr->SiS_VBInfo, SiS_Pr->SiS_SetFlag);
 #endif
 #endif
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-   xf86DrvMsg(0, X_PROBED, "(init301: VBInfo=0x%04x, SetFlag=0x%04x)\n",
-      SiS_Pr->SiS_VBInfo, SiS_Pr->SiS_SetFlag);
-#endif
-#endif
 }
 
 /*********************************************/
@@ -1415,12 +1409,6 @@ SiS_SetTVMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
    }
 
    SiS_Pr->SiS_VBInfo &= ~SetPALTV;
-
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-   xf86DrvMsg(0, X_INFO, "(init301: TVMode %x, VBInfo %x)\n", SiS_Pr->SiS_TVMode, SiS_Pr->SiS_VBInfo);
-#endif
-#endif
 }
 
 /*********************************************/
@@ -1447,18 +1435,6 @@ SiS_GetLCDInfoBIOS(struct SiS_Private *SiS_Pr)
    unsigned char  *ROMAddr;
    unsigned short temp;
 
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-   xf86DrvMsg(0, X_INFO, "Paneldata driver: [%d %d] [H %d %d] [V %d %d] [C %d 0x%02x 0x%02x]\n",
-	SiS_Pr->PanelHT, SiS_Pr->PanelVT,
-	SiS_Pr->PanelHRS, SiS_Pr->PanelHRE,
-	SiS_Pr->PanelVRS, SiS_Pr->PanelVRE,
-	SiS_Pr->SiS_VBVCLKData[SiS_Pr->PanelVCLKIdx315].CLOCK,
-	SiS_Pr->SiS_VBVCLKData[SiS_Pr->PanelVCLKIdx315].Part4_A,
-	SiS_Pr->SiS_VBVCLKData[SiS_Pr->PanelVCLKIdx315].Part4_B);
-#endif
-#endif
-
    if((ROMAddr = GetLCDStructPtr661(SiS_Pr))) {
       if((temp = SISGETROMW(6)) != SiS_Pr->PanelHT) {
 	 SiS_Pr->SiS_NeedRomModeData = true;
@@ -1480,18 +1456,6 @@ SiS_GetLCDInfoBIOS(struct SiS_Private *SiS_Pr)
       SiS_Pr->SiS_VCLKData[VCLK_CUSTOM_315].SR2C =
 	 SiS_Pr->SiS_VBVCLKData[VCLK_CUSTOM_315].Part4_B = ROMAddr[20];
 
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-      xf86DrvMsg(0, X_INFO, "Paneldata BIOS:  [%d %d] [H %d %d] [V %d %d] [C %d 0x%02x 0x%02x]\n",
-	SiS_Pr->PanelHT, SiS_Pr->PanelVT,
-	SiS_Pr->PanelHRS, SiS_Pr->PanelHRE,
-	SiS_Pr->PanelVRS, SiS_Pr->PanelVRE,
-	SiS_Pr->SiS_VBVCLKData[SiS_Pr->PanelVCLKIdx315].CLOCK,
-	SiS_Pr->SiS_VBVCLKData[SiS_Pr->PanelVCLKIdx315].Part4_A,
-	SiS_Pr->SiS_VBVCLKData[SiS_Pr->PanelVCLKIdx315].Part4_B);
-#endif
-#endif
-
    }
 #endif
 }
@@ -2192,11 +2156,6 @@ SiS_GetLCDResInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned sh
 	SiS_Pr->SiS_LCDInfo, SiS_Pr->SiS_LCDResInfo, SiS_Pr->SiS_LCDTypeInfo);
 #endif
 #endif
-#ifdef SIS_XORG_XF86
-  xf86DrvMsgVerb(0, X_PROBED, 4,
-	"(init301: LCDInfo=0x%04x LCDResInfo=0x%02x LCDTypeInfo=0x%02x SetFlag=0x%04x)\n",
-	SiS_Pr->SiS_LCDInfo, SiS_Pr->SiS_LCDResInfo, SiS_Pr->SiS_LCDTypeInfo, SiS_Pr->SiS_SetFlag);
-#endif
 }
 
 /*********************************************/
@@ -2410,12 +2369,6 @@ SiS_GetVCLK2Ptr(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned shor
 
   }
 
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-  xf86DrvMsg(0, X_INFO, "VCLKIndex %d (0x%x)\n", VCLKIndex, VCLKIndex);
-#endif
-#endif
-
   return VCLKIndex;
 }
 
@@ -3527,12 +3480,6 @@ SiS_GetCRT2Data301(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned s
 	      default                  : LCDPtr = SiS_Pr->SiS_ExtLCD1024x768Data;   break;
 	   }
 
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-	   xf86DrvMsg(0, X_INFO, "GetCRT2Data: Index %d ResIndex %d\n", CRT2Index, ResIndex);
-#endif
-#endif
-
 	   SiS_Pr->SiS_RVBHCMAX  = (LCDPtr+ResIndex)->RVBHCMAX;
 	   SiS_Pr->SiS_RVBHCFACT = (LCDPtr+ResIndex)->RVBHCFACT;
 	   SiS_Pr->SiS_VGAHT     = (LCDPtr+ResIndex)->VGAHT;
@@ -3891,11 +3838,6 @@ SiS_HandlePWD(struct SiS_Private *SiS_Pr)
 	 ret = 1;
       }
       SiS_SetRegANDOR(SiS_Pr->SiS_Part4Port,0x27,0x7f,temp);
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-      xf86DrvMsg(0, 0, "Setting PWD %x\n", temp);
-#endif
-#endif
    }
 #endif
    return ret;
@@ -5420,27 +5362,6 @@ SiS_SetGroup1_301(struct SiS_Private *SiS_Pr, unsigned short ModeNo,unsigned sho
 
   temp = SiS_GetRegByte((SiS_Pr->SiS_P3ca+0x02));
   SiS_SetReg(SiS_Pr->SiS_Part1Port,0x1b,temp);			/* ? */
-
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-   xf86DrvMsg(0, X_INFO, "%d %d %d %d  %d %d %d %d  (%d %d %d %d)\n",
-	SiS_Pr->CHDisplay, SiS_Pr->CHSyncStart, SiS_Pr->CHSyncEnd, SiS_Pr->CHTotal,
-	SiS_Pr->CVDisplay, SiS_Pr->CVSyncStart, SiS_Pr->CVSyncEnd, SiS_Pr->CVTotal,
-	SiS_Pr->CHBlankStart, SiS_Pr->CHBlankEnd, SiS_Pr->CVBlankStart, SiS_Pr->CVBlankEnd);
-
-   xf86DrvMsg(0, X_INFO, " {{0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,\n",
-	SiS_Pr->CCRT1CRTC[0], SiS_Pr->CCRT1CRTC[1],
-	SiS_Pr->CCRT1CRTC[2], SiS_Pr->CCRT1CRTC[3],
-	SiS_Pr->CCRT1CRTC[4], SiS_Pr->CCRT1CRTC[5],
-	SiS_Pr->CCRT1CRTC[6], SiS_Pr->CCRT1CRTC[7]);
-   xf86DrvMsg(0, X_INFO, "   0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,0x%02x,\n",
-	SiS_Pr->CCRT1CRTC[8], SiS_Pr->CCRT1CRTC[9],
-	SiS_Pr->CCRT1CRTC[10], SiS_Pr->CCRT1CRTC[11],
-	SiS_Pr->CCRT1CRTC[12], SiS_Pr->CCRT1CRTC[13],
-	SiS_Pr->CCRT1CRTC[14], SiS_Pr->CCRT1CRTC[15]);
-   xf86DrvMsg(0, X_INFO, "   0x%02x}},\n", SiS_Pr->CCRT1CRTC[16]);
-#endif
-#endif
 }
 
 /* Setup panel link
@@ -7130,12 +7051,6 @@ SiS_SetGroup2(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
 
     /* Non-expanding: lcdvdes = tempcx = VT-1; lcdvdee = tempbx = VDE-1 */
 
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-    xf86DrvMsg(0, X_INFO, "lcdvdes 0x%x lcdvdee 0x%x\n", tempcx, tempbx);
-#endif
-#endif
-
     SiS_SetReg(SiS_Pr->SiS_Part2Port,0x05,tempcx);	/* lcdvdes  */
     SiS_SetReg(SiS_Pr->SiS_Part2Port,0x06,tempbx);	/* lcdvdee  */
 
@@ -7184,12 +7099,6 @@ SiS_SetGroup2(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
        tempbx = SiS_Pr->CVSyncStart;
     }
 
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-    xf86DrvMsg(0, X_INFO, "lcdvrs 0x%x\n", tempbx);
-#endif
-#endif
-
     SiS_SetReg(SiS_Pr->SiS_Part2Port,0x04,tempbx);	    /* lcdvrs */
 
     temp = (tempbx >> 4) & 0xF0;
@@ -7201,12 +7110,6 @@ SiS_SetGroup2(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
        temp |= (SiS_Pr->CVSyncEnd & 0x0f);
     }
 
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-    xf86DrvMsg(0, X_INFO, "lcdvre[3:0] 0x%x\n", (temp & 0x0f));
-#endif
-#endif
-
     SiS_SetReg(SiS_Pr->SiS_Part2Port,0x01,temp);
 
 #ifdef SIS300
@@ -7245,12 +7148,6 @@ SiS_SetGroup2(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
        tempax >>= 1;
     }
 
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-    xf86DrvMsg(0, X_INFO, "lcdhdee 0x%x\n", tempbx);
-#endif
-#endif
-
     tempbx += bridgeoffset;
 
     SiS_SetReg(SiS_Pr->SiS_Part2Port,0x23,tempbx);	    /* lcdhdee */
@@ -7276,12 +7173,6 @@ SiS_SetGroup2(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
        tempbx += bridgeoffset;
     }
 
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-    xf86DrvMsg(0, X_INFO, "lcdhrs 0x%x\n", tempbx);
-#endif
-#endif
-
     SiS_SetReg(SiS_Pr->SiS_Part2Port,0x1C,tempbx);	    /* lcdhrs */
     SiS_SetRegANDOR(SiS_Pr->SiS_Part2Port,0x1D,0x0F,((tempbx >> 4) & 0xf0));
 
@@ -7300,12 +7191,6 @@ SiS_SetGroup2(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
        tempbx += bridgeoffset;
     }
 
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-    xf86DrvMsg(0, X_INFO, "lcdhre 0x%x\n", tempbx);
-#endif
-#endif
-
     SiS_SetReg(SiS_Pr->SiS_Part2Port,0x21,tempbx);	    /* lcdhre */
 
     SiS_SetGroup2_Tail(SiS_Pr, ModeNo);
@@ -8703,16 +8588,6 @@ SiS_SetCRT2Group(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
       SiS_GetLVDSDesData(SiS_Pr, ModeNo, ModeIdIndex, RefreshRateTableIndex);
    }
 
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-  xf86DrvMsg(0, X_INFO, "(init301: LCDHDES 0x%03x LCDVDES 0x%03x)\n", SiS_Pr->SiS_LCDHDES, SiS_Pr->SiS_LCDVDES);
-  xf86DrvMsg(0, X_INFO, "(init301: HDE     0x%03x VDE     0x%03x)\n", SiS_Pr->SiS_HDE, SiS_Pr->SiS_VDE);
-  xf86DrvMsg(0, X_INFO, "(init301: VGAHDE  0x%03x VGAVDE  0x%03x)\n", SiS_Pr->SiS_VGAHDE, SiS_Pr->SiS_VGAVDE);
-  xf86DrvMsg(0, X_INFO, "(init301: HT      0x%03x VT      0x%03x)\n", SiS_Pr->SiS_HT, SiS_Pr->SiS_VT);
-  xf86DrvMsg(0, X_INFO, "(init301: VGAHT   0x%03x VGAVT   0x%03x)\n", SiS_Pr->SiS_VGAHT, SiS_Pr->SiS_VGAVT);
-#endif
-#endif
-
    if(SiS_Pr->SiS_SetFlag & LowModeTests) {
       SiS_SetGroup1(SiS_Pr, ModeNo, ModeIdIndex, RefreshRateTableIndex);
    }
@@ -8923,11 +8798,6 @@ SiS_SetTrumpionBlock(struct SiS_Private *SiS_Pr, unsigned char *dataptr)
      dataptr = SiS_SetTrumpBlockLoop(SiS_Pr, dataptr);
      if(!dataptr) return false;
   }
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-  xf86DrvMsg(0, X_INFO, "Trumpion block success\n");
-#endif
-#endif
   return true;
 }
 #endif
@@ -9114,9 +8984,7 @@ SiS_SetCH70xxANDOR(struct SiS_Private *SiS_Pr, unsigned short reg,
 }
 
 /* Our own DDC functions */
-#ifndef SIS_XORG_XF86
 static
-#endif
 unsigned short
 SiS_InitDDCRegs(struct SiS_Private *SiS_Pr, unsigned int VBFlags, int VGAEngine,
                 unsigned short adaptnum, unsigned short DDCdatatype, bool checkcr32,
@@ -9224,12 +9092,6 @@ SiS_InitDDCRegs(struct SiS_Private *SiS_Pr, unsigned int VBFlags, int VGAEngine,
 
     SiS_SetupDDCN(SiS_Pr);
 
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-    xf86DrvMsg(0, X_INFO, "DDC Port %x Index %x Shift %d\n",
-    		SiS_Pr->SiS_DDC_Port, SiS_Pr->SiS_DDC_Index, temp);
-#endif
-#endif
     return 0;
 }
 
@@ -9292,11 +9154,6 @@ SiS_DoProbeDDC(struct SiS_Private *SiS_Pr)
     SiS_SetSwitchDDC2(SiS_Pr);
     if(SiS_PrepareDDC(SiS_Pr)) {
          SiS_SetStop(SiS_Pr);
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-         xf86DrvMsg(0, X_INFO, "Probe: Prepare failed\n");
-#endif
-#endif
          return 0xFFFF;
     }
     mask = 0xf0;
@@ -9310,11 +9167,6 @@ SiS_DoProbeDDC(struct SiS_Private *SiS_Pr)
        } else {
            failed = true;
 	   ret = 0xFFFF;
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-           xf86DrvMsg(0, X_INFO, "Probe: Read 1 failed\n");
-#endif
-#endif
        }
     }
     if(!failed) {
@@ -9324,11 +9176,6 @@ SiS_DoProbeDDC(struct SiS_Private *SiS_Pr)
        if(temp == value) ret = 0;
        else {
           ret = 0xFFFF;
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-          xf86DrvMsg(0, X_INFO, "Probe: Read 2 failed\n");
-#endif
-#endif
           if(SiS_Pr->SiS_DDC_DeviceAddr == 0xa0) {
              if(temp == 0x30) ret = 0;
           }
@@ -9338,9 +9185,7 @@ SiS_DoProbeDDC(struct SiS_Private *SiS_Pr)
     return ret;
 }
 
-#ifndef SIS_XORG_XF86
 static
-#endif
 unsigned short
 SiS_ProbeDDC(struct SiS_Private *SiS_Pr)
 {
@@ -9357,9 +9202,7 @@ SiS_ProbeDDC(struct SiS_Private *SiS_Pr)
    return flag;
 }
 
-#ifndef SIS_XORG_XF86
 static
-#endif
 unsigned short
 SiS_ReadDDC(struct SiS_Private *SiS_Pr, unsigned short DDCdatatype, unsigned char *buffer)
 {
@@ -9606,11 +9449,6 @@ SiS_SetSCLKHigh(struct SiS_Private *SiS_Pr)
     temp = SiS_GetReg(SiS_Pr->SiS_DDC_Port,SiS_Pr->SiS_DDC_Index);
   } while((!(temp & SiS_Pr->SiS_DDC_Clk)) && --watchdog);
   if (!watchdog) {
-#ifdef SIS_XORG_XF86
-#ifdef TWDEBUG
-        xf86DrvMsg(0, X_INFO, "SetClkHigh failed\n");
-#endif
-#endif
   	return 0xFFFF;
   }
   SiS_DDC2Delay(SiS_Pr,SiS_I2CDELAYSHORT);
diff --git a/drivers/video/sis/init301.h b/drivers/video/sis/init301.h
index 51d9922..c379dc7 100644
--- a/drivers/video/sis/init301.h
+++ b/drivers/video/sis/init301.h
@@ -56,11 +56,6 @@
 #include "osdef.h"
 #include "initdef.h"
 
-#ifdef SIS_XORG_XF86
-#include "sis.h"
-#include "sis_regs.h"
-#endif
-
 #ifdef SIS_LINUX_KERNEL
 #include "vgatypes.h"
 #include "vstruct.h"
@@ -412,21 +407,12 @@ unsigned short	SiS_HandleDDC(struct SiS_Private *SiS_Pr, unsigned int VBFlags, i
 			unsigned short adaptnum, unsigned short DDCdatatype,
 			unsigned char *buffer, unsigned int VBFlags2);
 
-#ifdef SIS_XORG_XF86
-unsigned short		SiS_InitDDCRegs(struct SiS_Private *SiS_Pr, unsigned int VBFlags,
-				int VGAEngine, unsigned short adaptnum, unsigned short DDCdatatype,
-				bool checkcr32, unsigned int VBFlags2);
-unsigned short		SiS_ProbeDDC(struct SiS_Private *SiS_Pr);
-unsigned short		SiS_ReadDDC(struct SiS_Private *SiS_Pr, unsigned short DDCdatatype,
-				unsigned char *buffer);
-#else
 static unsigned short	SiS_InitDDCRegs(struct SiS_Private *SiS_Pr, unsigned int VBFlags,
 				int VGAEngine, unsigned short adaptnum, unsigned short DDCdatatype,
 				bool checkcr32, unsigned int VBFlags2);
 static unsigned short	SiS_ProbeDDC(struct SiS_Private *SiS_Pr);
 static unsigned short	SiS_ReadDDC(struct SiS_Private *SiS_Pr, unsigned short DDCdatatype,
 				unsigned char *buffer);
-#endif
 static void		SiS_SetSwitchDDC2(struct SiS_Private *SiS_Pr);
 static unsigned short	SiS_SetStart(struct SiS_Private *SiS_Pr);
 static unsigned short	SiS_SetStop(struct SiS_Private *SiS_Pr);
diff --git a/drivers/video/sis/osdef.h b/drivers/video/sis/osdef.h
index 6ff8f98..e24d21a 100644
--- a/drivers/video/sis/osdef.h
+++ b/drivers/video/sis/osdef.h
@@ -56,7 +56,6 @@
 
 /* The choices are: */
 #define SIS_LINUX_KERNEL		/* Linux kernel framebuffer */
-#undef  SIS_XORG_XF86			/* XFree86/X.org */
 
 #ifdef OutPortByte
 #undef OutPortByte
@@ -111,23 +110,4 @@
 
 #endif /* LINUX_KERNEL */
 
-/**********************************************************************/
-/*  XFree86/X.org                                                    */
-/**********************************************************************/
-
-#ifdef SIS_XORG_XF86
-
-#define SIS300
-#define SIS315H
-
-#define OutPortByte(p,v) outSISREG((IOADDRESS)(p),(CARD8)(v))
-#define OutPortWord(p,v) outSISREGW((IOADDRESS)(p),(CARD16)(v))
-#define OutPortLong(p,v) outSISREGL((IOADDRESS)(p),(CARD32)(v))
-#define InPortByte(p)    inSISREG((IOADDRESS)(p))
-#define InPortWord(p)    inSISREGW((IOADDRESS)(p))
-#define InPortLong(p)    inSISREGL((IOADDRESS)(p))
-#define SiS_SetMemory(MemoryAddress,MemorySize,value) memset(MemoryAddress, value, MemorySize)
-
-#endif /* XF86 */
-
 #endif  /* _OSDEF_H_ */
diff --git a/drivers/video/sis/vgatypes.h b/drivers/video/sis/vgatypes.h
index 81a22ea..f499062 100644
--- a/drivers/video/sis/vgatypes.h
+++ b/drivers/video/sis/vgatypes.h
@@ -62,15 +62,6 @@ typedef unsigned long SISIOADDRESS;
 #define SISIOMEMTYPE __iomem
 #endif
 
-#ifdef SIS_XORG_XF86
-#if XF86_VERSION_CURRENT < XF86_VERSION_NUMERIC(4,2,0,0,0)
-typedef unsigned long IOADDRESS;
-typedef unsigned long SISIOADDRESS;
-#else
-typedef IOADDRESS SISIOADDRESS;
-#endif
-#endif
-
 typedef enum _SIS_CHIP_TYPE {
     SIS_VGALegacy = 0,
     SIS_530,
diff --git a/drivers/video/sis/vstruct.h b/drivers/video/sis/vstruct.h
index bef4aae..a860039 100644
--- a/drivers/video/sis/vstruct.h
+++ b/drivers/video/sis/vstruct.h
@@ -233,9 +233,6 @@ struct SiS_Private
 {
 	unsigned char			ChipType;
 	unsigned char			ChipRevision;
-#ifdef SIS_XORG_XF86
-	PCITAG				PciTag;
-#endif
 #ifdef SIS_LINUX_KERNEL
 	void				*ivideo;
 #endif
@@ -280,9 +277,6 @@ struct SiS_Private
 	unsigned short			SiS_IF_DEF_FSTN;
 	unsigned short			SiS_SysFlags;
 	unsigned char			SiS_VGAINFO;
-#ifdef SIS_XORG_XF86
-	unsigned short			SiS_CP1, SiS_CP2, SiS_CP3, SiS_CP4;
-#endif
 	bool				SiS_UseROM;
 	bool				SiS_ROMNew;
 	bool				SiS_XGIROM;
-- 
1.5.6.5


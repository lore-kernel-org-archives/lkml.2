Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933690Ab0FEQGh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 12:06:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48515 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933640Ab0FEQFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 12:05:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JgL0ou51TuKQjxYVhSlUXofcBpKdo2Ulv21cShBhD2n1LfSUYbbOxF9q3QyDURSlL5
         BQnW7v1tClGokwAvwCGdn4oUOJSJ4joz4UO3AH7fvlSLB+xbUUOwSyyvnNqK5L/B9zmB
         kNXZZQZA5FBZG8cvA/fSlo68tgXZ5usawhffs=
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Cc: linux-kernel@vger.kernel.org,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: [PATCH 3/7] Remove TC specific code.
Date: Sat,  5 Jun 2010 18:04:21 +0200
Message-Id: <1275753865-5435-4-git-send-email-riccardo.magliocchetti@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275753865-5435-1-git-send-email-riccardo.magliocchetti@gmail.com>
References: <1275753865-5435-1-git-send-email-riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
---
 drivers/staging/xgifb/osdef.h      |   22 ----
 drivers/staging/xgifb/vb_setmode.c |  196 ------------------------------------
 drivers/staging/xgifb/vb_util.c    |   11 --
 3 files changed, 0 insertions(+), 229 deletions(-)

diff --git a/drivers/staging/xgifb/osdef.h b/drivers/staging/xgifb/osdef.h
index 0d634f8..ec1c32a 100644
--- a/drivers/staging/xgifb/osdef.h
+++ b/drivers/staging/xgifb/osdef.h
@@ -1,7 +1,6 @@
 #ifndef _OSDEF_H_
 #define _OSDEF_H_
 
-/* #define TC */
 #define LINUX_KERNEL
 /* #define LINUX_XF86 */
 
@@ -12,8 +11,6 @@
 
 
 /**********************************************************************/
-#ifdef TC
-#endif
 #ifdef LINUX_XF86
 #define LINUX
 #endif
@@ -22,9 +19,6 @@
 #endif
 
 /**********************************************************************/
-#ifdef TC
-#define XGI_SetMemory(MemoryAddress,MemorySize,value) memset(MemoryAddress, value, MemorySize);
-#endif
 #ifdef LINUX_XF86
 #define XGI_SetMemory(MemoryAddress,MemorySize,value) memset(MemoryAddress, value, MemorySize)
 #endif
@@ -35,9 +29,6 @@
 
 /**********************************************************************/
 
-#ifdef TC
-#define XGI_MemoryCopy(Destination,Soruce,Length) memmove(Destination, Soruce, Length);
-#endif
 #ifdef LINUX_XF86
 #define XGI_MemoryCopy(Destination,Soruce,Length) memcpy(Destination,Soruce,Length)
 #endif
@@ -72,19 +63,6 @@
 #endif /* InPortLong */
 
 /**********************************************************************/
-/*  TC                                                                */
-/**********************************************************************/
-
-#ifdef TC
-#define OutPortByte(p,v) outp((unsigned short)(p),(unsigned char)(v))
-#define OutPortWord(p,v) outp((unsigned short)(p),(unsigned short)(v))
-#define OutPortLong(p,v) outp((unsigned short)(p),(unsigned long)(v))
-#define InPortByte(p)    inp((unsigned short)(p))
-#define InPortWord(p)    inp((unsigned short)(p))
-#define InPortLong(p)    ((inp((unsigned short)(p+2))<<16) | inp((unsigned short)(p)))
-#endif
-
-/**********************************************************************/
 /*  LINUX XF86                                                        */
 /**********************************************************************/
 
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 7041440..e7912ea 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -1,13 +1,5 @@
 #include "osdef.h"
 
-#ifdef TC
-#include <stdio.h>
-#include <string.h>
-#include <conio.h>
-#include <dos.h>
-#endif
-
-
 #ifdef LINUX_XF86
 #include "xf86.h"
 #include "xf86PciInfo.h"
@@ -3992,58 +3984,6 @@ BOOLEAN XGI_GetLCDInfo( USHORT ModeNo , USHORT ModeIdIndex, PVB_DEVICE_INFO pVBI
 BOOLEAN XGI_SearchModeID( USHORT ModeNo , USHORT *ModeIdIndex, PVB_DEVICE_INFO pVBInfo )
 {
 
-#ifdef TC
-
-    if ( ModeNo <= 5 )
-        ModeNo |= 1 ;
-
-    if ( ModeNo <= 0x13 )
-    {
-        /* for (*ModeIdIndex=0;*ModeIdIndex<sizeof(pVBInfo->SModeIDTable)/sizeof(XGI_StStruct);(*ModeIdIndex)++) */
-        for( *ModeIdIndex = 0 ; ; ( *ModeIdIndex )++ )
-        {
-            if ( pVBInfo->SModeIDTable[ *ModeIdIndex ].St_ModeID == ModeNo )
-                break ;
-            if ( pVBInfo->SModeIDTable[ *ModeIdIndex ].St_ModeID == 0xFF )
-                return( FALSE ) ;
-        }
-
-        VGA_INFO = ( PUCHAR )MK_FP( 0 , 0x489 ) ;
-
-        if ( ModeNo == 0x07 )
-        {
-            if ( ( *VGA_INFO & 0x10 ) != 0 )
-                ( *ModeIdIndex )++ ; /* 400 lines */
-            /* else 350 lines */
-        }
-
-        if ( ModeNo <= 3 )
-        {
-            if ( ( *VGA_INFO & 0x80 ) == 0 )
-            {
-                ( *ModeIdIndex )++ ;
-                if ( ( *VGA_INFO & 0x10 ) != 0 )
-                    ( *ModeIdIndex )++ ; /* 400 lines */
-                /* else 350 lines */
-            }
-            /* else 200 lines */
-        }
-    }
-    else
-    {
-        /* for (*ModeIdIndex=0;*ModeIdIndex<sizeof(pVBInfo->EModeIDTable)/sizeof(XGI_ExtStruct);(*ModeIdIndex)++) */
-        for( *ModeIdIndex = 0 ; ; ( *ModeIdIndex )++ )
-        {
-            if ( pVBInfo->EModeIDTable[ *ModeIdIndex ].Ext_ModeID == ModeNo )
-                break ;
-            if ( pVBInfo->EModeIDTable[ *ModeIdIndex ].Ext_ModeID == 0xFF )
-                return( FALSE ) ;
-        }
-    }
-
-
-#endif
-
 #ifdef LINUX /* chiawen for linux solution */
 
     if ( ModeNo <= 5 )
@@ -4443,142 +4383,6 @@ void XGI_SenseCRT1( PVB_DEVICE_INFO pVBInfo )
 
 
 
-#ifdef TC
-/* --------------------------------------------------------------------- */
-/* Function : INT1AReturnCode */
-/* Input : */
-/* Output : */
-/* Description : */
-/* --------------------------------------------------------------------- */
-int INT1AReturnCode( union REGS regs )
-{
-    if ( regs.x.cflag )
-    {
-        /* printf( "Error to find pci device!\n" ) ; */
-        return( 1 ) ;
-    }
-
-    switch(regs.h.ah)
-    {
-        case 0: return 0;
-            break ;
-        case 0x81:
-            printf( "Function not support\n" ) ;
-            break ;
-        case 0x83:
-            printf( "bad vendor id\n" ) ;
-            break ;
-        case 0x86:
-            printf( "device not found\n" ) ;
-            break ;
-        case 0x87:
-            printf( "bad register number\n" ) ;
-            break ;
-        case 0x88:
-            printf( "set failed\n" ) ;
-            break ;
-        case 0x89:
-            printf( "buffer too small" ) ;
-            break ;
-        default:
-            break ;
-    }
-    return( 1 ) ;
-}
-
-
-/* --------------------------------------------------------------------- */
-/* Function : FindPCIIOBase */
-/* Input : */
-/* Output : */
-/* Description : */
-/* --------------------------------------------------------------------- */
-unsigned FindPCIIOBase( unsigned index , unsigned deviceid )
-{
-    union REGS regs ;
-
-    regs.h.ah = 0xb1 ;	/* PCI_FUNCTION_ID */
-    regs.h.al = 0x02 ;	/* FIND_PCI_DEVICE */
-    regs.x.cx = deviceid ;
-    regs.x.dx = 0x1039 ;
-    regs.x.si = index ;	/* find n-th device */
-
-    int86( 0x1A , &regs , &regs ) ;
-
-    if ( INT1AReturnCode( regs ) != 0 )
-        return( 0 ) ;
-
-    /* regs.h.bh bus number */
-    /* regs.h.bl device number */
-    regs.h.ah = 0xb1 ;  /* PCI_FUNCTION_ID */
-    regs.h.al = 0x09 ;  /* READ_CONFIG_WORD */
-    regs.x.cx = deviceid ;
-    regs.x.dx = 0x1039 ;
-    regs.x.di = 0x18 ;  /* register number */
-    int86( 0x1A , &regs , &regs ) ;
-
-    if ( INT1AReturnCode( regs ) != 0 )
-        return( 0 ) ;
-
-    return( regs.x.cx ) ;
-}
-
-#endif
-
-
-
-#ifdef TC
-/* --------------------------------------------------------------------- */
-/* Function : main */
-/* Input : */
-/* Output : */
-/* Description : */
-/* --------------------------------------------------------------------- */
-void main(int argc, char *argv[])
-{
-    XGI_HW_DEVICE_INFO HwDeviceExtension ;
-    USHORT temp ;
-    USHORT ModeNo ;
-
-    /* HwDeviceExtension.pjVirtualRomBase =(PUCHAR) MK_FP(0xC000,0); */
-    /* HwDeviceExtension.pjVideoMemoryAddress = (PUCHAR)MK_FP(0xA000,0); */
-
-
-    HwDeviceExtension.pjIOAddress = ( FindPCIIOBase( 0 ,0x6300 ) & 0xFF80 ) + 0x30 ;
-    HwDeviceExtension.jChipType = XGI_340 ;
-
-
-
-    /* HwDeviceExtension.pjIOAddress = ( FindPCIIOBase( 0 , 0x5315 ) & 0xFF80 ) + 0x30 ; */
-
-    HwDeviceExtension.pjIOAddress = ( FindPCIIOBase( 0 , 0x330 ) & 0xFF80 ) + 0x30 ;
-    HwDeviceExtension.jChipType = XGI_340 ;
-
-
-    HwDeviceExtension.ujVBChipID = VB_CHIP_301 ;
-    StrCpy(HwDeviceExtension.szVBIOSVer , "0.84" ) ;
-    HwDeviceExtension.bSkipDramSizing = FALSE ;
-    HwDeviceExtension.ulVideoMemorySize = 0 ;
-
-    if ( argc == 2 )
-    {
-        ModeNo = atoi( argv[ 1 ] ) ;
-    }
-    else
-    {
-        ModeNo = 0x2e ;
-        /* ModeNo = 0x37 ; 1024x768x 4bpp */
-        /* ModeNo = 0x38 ; 1024x768x 8bpp */
-        /* ModeNo = 0x4A ; 1024x768x 16bpp */
-        /* ModeNo = 0x47 ; 800x600x 16bpp */
-    }
-
-    /* XGIInitNew( &HwDeviceExtension ) ; */
-    XGISetModeNew( &HwDeviceExtension , ModeNo ) ;
-}
-#endif
-
-
 /* --------------------------------------------------------------------- */
 /* Function : XGI_WaitDisplay */
 /* Input : */
diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index 96fa683..e88426f 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -9,13 +9,6 @@
 #include <linux/types.h>
 #endif
 
-#ifdef TC
-#include <stdio.h>
-#include <string.h>
-#include <conio.h>
-#include <dos.h>
-#endif
-
 #ifdef LINUX_XF86
 #include "xf86.h"
 #include "xf86PciInfo.h"
@@ -212,10 +205,6 @@ void NewDelaySeconds( int seconds )
 
     for( i = 0 ; i < seconds ; i++ )
     {
-#ifdef TC
-        delay( 1000 ) ;
-#endif
-
     }
 }
 
-- 
1.7.1


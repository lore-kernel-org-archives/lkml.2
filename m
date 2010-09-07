Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab0IGVSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 17:18:10 -0400
Received: from mail.atheros.com ([12.19.149.2]:56450 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168Ab0IGVSF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 17:18:05 -0400
From: Vipin Mehta <Vipin.Mehta@Atheros.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Date: Tue, 7 Sep 2010 14:18:02 -0700
Subject: RE: [PATCH 2/2] staging: ath6kl: use native methods from kernel
 library
Thread-Topic: [PATCH 2/2] staging: ath6kl: use native methods from kernel
 library
Thread-Index: ActOoIB9bs3/vG1mQT6ziwhOIi0KyAAL/wEQ
Message-ID: <35B17FE5076C7040809188FBE7913F983F23479F74@SC1EXMB-MBCL.global.atheros.com>
References: <09b7da2e5462e0b855617ff5308ed6efb4fc9cab.1283872748.git.andy.shevchenko@gmail.com>
 <8b251244717765e795b92a1f7335f8af98e5706f.1283872748.git.andy.shevchenko@gmail.com>
In-Reply-To: <8b251244717765e795b92a1f7335f8af98e5706f.1283872748.git.andy.shevchenko@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy,
   Thanks for the patch. Although the driver supports Linux but it has been architected to support other OSes if desired. The code is, therefore, organized into generic and OS specific components with the latter part of the code captured into the os/linux directory. As such, the patch will be more useful if we can move out the inclusion of linux specific header files <linux/kernel.h> and <linux/ctype.h> into a header file in os/linux/include directory. You can refer to os/linux/include/osapi_linux.h for example. A macro could be defined which would use linux specific APIs for Linux and keep the original definitions for any other OS.

I'll update the documentation on the ath6kl wiki to make it more informative.

Regards,
Vipin


> -----Original Message-----
> From: devel-bounces@linuxdriverproject.org [mailto:devel-
> bounces@linuxdriverproject.org] On Behalf Of Andy Shevchenko
> Sent: Tuesday, September 07, 2010 8:20 AM
> To: linux-kernel@vger.kernel.org; Greg Kroah-Hartman;
> devel@driverdev.osuosl.org
> Cc: Andy Shevchenko
> Subject: [PATCH 2/2] staging: ath6kl: use native methods from kernel
> library
> 
> There are already implemented methods such hex_to_bin() or isxdigit() in
> the kernel. Let's use them.
> 
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> ---
>  .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   |   31 ++++++---------
> ----
>  drivers/staging/ath6kl/os/linux/eeprom.c           |   32 +++++++++------
> ----
>  2 files changed, 25 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
> b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
> index 5eed8ac..8dce054 100644
> --- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
> +++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
> @@ -27,6 +27,9 @@
> 
>  #include "ar3kpsparser.h"
> 
> +#include <linux/ctype.h>
> +#include <linux/kernel.h>
> +
>  #define BD_ADDR_SIZE            6
>  #define WRITE_PATCH             8
>  #define ENABLE_PATCH            11
> @@ -61,20 +64,6 @@
>  #define MAX_BYTE_LENGTH                   244
> 
>  #define SKIP_BLANKS(str) while (*str == ' ') str++
> -#define MIN(x, y) (((x) <= (y))? (x):(y))
> -#define MAX(x, y) (((x) >= (y))? (x):(y))
> -
> -#define UNUSED(x) (x=x)
> -
> -#define IS_BETWEEN(x, lower, upper) (((lower) <= (x)) && ((x) <=
> (upper)))
> -#define IS_DIGIT(c) (IS_BETWEEN((c), '0', '9'))
> -#define IS_HEX(c)   (IS_BETWEEN((c), '0', '9') || IS_BETWEEN((c), 'a',
> 'f') || IS_BETWEEN((c), 'A', 'F'))
> -#define TO_LOWER(c) (IS_BETWEEN((c), 'A', 'Z') ? ((c) - 'A' + 'a') : (c))
> -#define IS_BLANK(c) ((c) == ' ')
> -#define CONV_DEC_DIGIT_TO_VALUE(c) ((c) - '0')
> -#define CONV_HEX_DIGIT_TO_VALUE(c) (IS_DIGIT(c) ? ((c) - '0') :
> (IS_BETWEEN((c), 'A', 'Z') ? ((c) - 'A' + 10) : ((c) - 'a' + 10)))
> -#define CONV_VALUE_TO_HEX(v) ((A_UINT8)( ((v & 0x0F) <= 9) ? ((v & 0x0F)
> + '0') : ((v & 0x0F) - 10 + 'A') ) )
> -
> 
>  enum MinBootFileFormatE
>  {
> @@ -483,12 +472,12 @@ A_STATUS AthParseFilesUnified(A_UCHAR
> *srcbuffer,A_UINT32 srclen, int FileFormat
>                      if((stPS_DataFormat.eDataType == eHex) &&
> stPS_DataFormat.bIsArray == true) {
>                         while(uReadCount > 0) {
> 
> PsTagEntry[TagCount].TagData[stReadStatus.uByteCount] =
> -
> (A_UINT8)(CONV_HEX_DIGIT_TO_VALUE(pCharLine[stReadStatus.uCharCount]) <<
> 4)
> -                                                     |
> (A_UINT8)(CONV_HEX_DIGIT_TO_VALUE(pCharLine[stReadStatus.uCharCount +
> 1]));
> +
> (A_UINT8)(hex_to_bin(pCharLine[stReadStatus.uCharCount]) << 4)
> +                                                     |
> (A_UINT8)(hex_to_bin(pCharLine[stReadStatus.uCharCount + 1]));
> 
> 
> PsTagEntry[TagCount].TagData[stReadStatus.uByteCount+1] =
> -
> (A_UINT8)(CONV_HEX_DIGIT_TO_VALUE(pCharLine[stReadStatus.uCharCount + 3])
> << 4)
> -                                                     |
> (A_UINT8)(CONV_HEX_DIGIT_TO_VALUE(pCharLine[stReadStatus.uCharCount +
> 4]));
> +
> (A_UINT8)(hex_to_bin(pCharLine[stReadStatus.uCharCount + 3]) << 4)
> +                                                     |
> (A_UINT8)(hex_to_bin(pCharLine[stReadStatus.uCharCount + 4]));
> 
>                             stReadStatus.uCharCount += 6; // read two
> bytes, plus a space;
>                             stReadStatus.uByteCount += 2;
> @@ -574,14 +563,14 @@ A_STATUS GetNextTwoChar(A_UCHAR *srcbuffer,A_UINT32
> len, A_UINT32 *pos, char * b
>      unsigned char ch;
> 
>      ch = AthReadChar(srcbuffer,len,pos);
> -    if(ch != '\0' && IS_HEX(ch)) {
> +    if(ch != '\0' && isxdigit(ch)) {
>          buffer[0] =  ch;
>      } else
>      {
>          return A_ERROR;
>      }
>      ch = AthReadChar(srcbuffer,len,pos);
> -    if(ch != '\0' && IS_HEX(ch)) {
> +    if(ch != '\0' && isxdigit(ch)) {
>          buffer[1] =  ch;
>      } else
>      {
> @@ -606,7 +595,7 @@ A_STATUS AthDoParsePatch(A_UCHAR *patchbuffer,
> A_UINT32 patchlen)
>      Patch_Count = 0;
> 
>      while(NULL !=
> AthGetLine(Line,MAX_BYTE_LENGTH,patchbuffer,patchlen,&filepos)) {
> -        if(strlen(Line) <= 1 || !IS_HEX(Line[0])) {
> +        if(strlen(Line) <= 1 || !isxdigit(Line[0])) {
>              continue;
>          } else {
>              break;
> diff --git a/drivers/staging/ath6kl/os/linux/eeprom.c
> b/drivers/staging/ath6kl/os/linux/eeprom.c
> index 8dd130a..be77fb8 100644
> --- a/drivers/staging/ath6kl/os/linux/eeprom.c
> +++ b/drivers/staging/ath6kl/os/linux/eeprom.c
> @@ -71,24 +71,22 @@ wmic_ether_aton(const char *orig, A_UINT8 *eth)
>    i = 0;
>    for(bufp = orig; *bufp != '\0'; ++bufp) {
>      unsigned int val;
> -    unsigned char c = *bufp++;
> -    if (c >= '0' && c <= '9') val = c - '0';
> -    else if (c >= 'a' && c <= 'f') val = c - 'a' + 10;
> -    else if (c >= 'A' && c <= 'F') val = c - 'A' + 10;
> -    else {
> -        printk("%s: MAC value is invalid\n", __FUNCTION__);
> -        break;
> -    }
> +	int h, l;
> 
> -    val <<= 4;
> -    c = *bufp++;
> -    if (c >= '0' && c <= '9') val |= c - '0';
> -    else if (c >= 'a' && c <= 'f') val |= c - 'a' + 10;
> -    else if (c >= 'A' && c <= 'F') val |= c - 'A' + 10;
> -    else {
> -        printk("%s: MAC value is invalid\n", __FUNCTION__);
> -        break;
> -    }
> +	h = hex_to_bin(*bufp++);
> +
> +	if (h < 0) {
> +		printk("%s: MAC value is invalid\n", __FUNCTION__);
> +		break;
> +	}
> +
> +	l = hex_to_bin(*bufp++);
> +	if (l < 0) {
> +		printk("%s: MAC value is invalid\n", __FUNCTION__);
> +		break;
> +	}
> +
> +	val = (h << 4) | l;
> 
>      eth[i] = (unsigned char) (val & 0377);
>      if(++i == ATH_MAC_LEN) {
> --
> 1.7.2.2
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel

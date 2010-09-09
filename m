Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab0IIF7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 01:59:33 -0400
Received: from mail.atheros.com ([12.19.149.2]:47945 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab0IIF70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 01:59:26 -0400
From: Vipin Mehta <Vipin.Mehta@Atheros.com>
To: Kulikov Vasiliy <segooon@gmail.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 8 Sep 2010 22:59:15 -0700
Subject: RE: [PATCH 04/14] staging: ath6kl: check return code of get_user
 and put_user
Thread-Topic: [PATCH 04/14] staging: ath6kl: check return code of get_user
 and put_user
Thread-Index: ActNKLcKEL3Mee6uTJyDwhno+Ik6fACtunyg
Message-ID: <35B17FE5076C7040809188FBE7913F983F2381DB98@SC1EXMB-MBCL.global.atheros.com>
References: <1283711550-7246-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1283711550-7246-1-git-send-email-segooon@gmail.com>
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

Hi Vasiliy,
    You mentioned in your email that you were unable to compile the driver. Can you pls reproduce a log of the errors you observed?

Regards,
Vipin

> -----Original Message-----
> From: Kulikov Vasiliy [mailto:segooon@gmail.com]
> Sent: Sunday, September 05, 2010 11:32 AM
> To: kernel-janitors@vger.kernel.org
> Cc: Vasiliy Kulikov; Greg Kroah-Hartman; Vipin Mehta;
> devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 04/14] staging: ath6kl: check return code of get_user and
> put_user
>
> From: Vasiliy Kulikov <segooon@gmail.com>
>
> Function get_user may fail. Check for it.
>
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  I couldn't compile this driver at all, so it is not tested.
>
>  drivers/staging/ath6kl/os/linux/ioctl.c |  214 +++++++++++++++++++++-----
> -----
>  1 files changed, 149 insertions(+), 65 deletions(-)
>
> diff --git a/drivers/staging/ath6kl/os/linux/ioctl.c
> b/drivers/staging/ath6kl/os/linux/ioctl.c
> index 02af4b9..82cba85 100644
> --- a/drivers/staging/ath6kl/os/linux/ioctl.c
> +++ b/drivers/staging/ath6kl/os/linux/ioctl.c
> @@ -1874,7 +1874,10 @@ int ar6000_ioctl(struct net_device *dev, struct
> ifreq *rq, int cmd)
>           * the first word of the parameter block, and use the command
>           * AR6000_IOCTL_EXTENDED_CMD on the ioctl call.
>           */
> -        get_user(cmd, (int *)rq->ifr_data);
> +     if (get_user(cmd, (int *)rq->ifr_data)) {
> +         ret = -EFAULT;
> +         goto ioctl_done;
> +     }
>          userdata = (char *)(((unsigned int *)rq->ifr_data)+1);
>          if(is_xioctl_allowed(ar->arNextMode, cmd) != A_OK) {
>              A_PRINTF("xioctl: cmd=%d not allowed in this mode\n",cmd);
> @@ -2094,8 +2097,12 @@ int ar6000_ioctl(struct net_device *dev, struct
> ifreq *rq, int cmd)
>              break;
>
>          case AR6000_XIOCTL_BMI_READ_MEMORY:
> -            get_user(address, (unsigned int *)userdata);
> -            get_user(length, (unsigned int *)userdata + 1);
> +          if (get_user(address, (unsigned int *)userdata) ||
> +             get_user(length, (unsigned int *)userdata + 1)) {
> +             ret = -EFAULT;
> +             break;
> +         }
> +
>              AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("Read Memory (address: 0x%x,
> length: %d)\n",
>                               address, length));
>              if ((buffer = (unsigned char *)A_MALLOC(length)) != NULL) {
> @@ -2111,8 +2118,11 @@ int ar6000_ioctl(struct net_device *dev, struct
> ifreq *rq, int cmd)
>              break;
>
>          case AR6000_XIOCTL_BMI_WRITE_MEMORY:
> -            get_user(address, (unsigned int *)userdata);
> -            get_user(length, (unsigned int *)userdata + 1);
> +          if (get_user(address, (unsigned int *)userdata) ||
> +             get_user(length, (unsigned int *)userdata + 1)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>              AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("Write Memory (address: 0x%x,
> length: %d)\n",
>                               address, length));
>              if ((buffer = (unsigned char *)A_MALLOC(length)) != NULL) {
> @@ -2136,29 +2146,49 @@ int ar6000_ioctl(struct net_device *dev, struct
> ifreq *rq, int cmd)
>             break;
>
>          case AR6000_XIOCTL_BMI_EXECUTE:
> -            get_user(address, (unsigned int *)userdata);
> -            get_user(param, (unsigned int *)userdata + 1);
> +          if (get_user(address, (unsigned int *)userdata) ||
> +             get_user(param, (unsigned int *)userdata + 1)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>              AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("Execute (address: 0x%x,
> param: %d)\n",
>                               address, param));
>              ret = BMIExecute(hifDevice, address, (A_UINT32*)&param);
> -            put_user(param, (unsigned int *)rq->ifr_data); /* return
> value */
> +         /* return value */
> +         if (put_user(param, (unsigned int *)rq->ifr_data)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>              break;
>
>          case AR6000_XIOCTL_BMI_SET_APP_START:
> -            get_user(address, (unsigned int *)userdata);
> +         if (get_user(address, (unsigned int *)userdata)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>              AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("Set App Start (address:
> 0x%x)\n", address));
>              ret = BMISetAppStart(hifDevice, address);
>              break;
>
>          case AR6000_XIOCTL_BMI_READ_SOC_REGISTER:
> -            get_user(address, (unsigned int *)userdata);
> +         if (get_user(address, (unsigned int *)userdata)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>              ret = BMIReadSOCRegister(hifDevice, address,
> (A_UINT32*)&param);
> -            put_user(param, (unsigned int *)rq->ifr_data); /* return
> value */
> +         /* return value */
> +         if (put_user(param, (unsigned int *)rq->ifr_data)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>              break;
>
>          case AR6000_XIOCTL_BMI_WRITE_SOC_REGISTER:
> -            get_user(address, (unsigned int *)userdata);
> -            get_user(param, (unsigned int *)userdata + 1);
> +         if (get_user(address, (unsigned int *)userdata) ||
> +             get_user(param, (unsigned int *)userdata + 1)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>              ret = BMIWriteSOCRegister(hifDevice, address, param);
>              break;
>
> @@ -2196,12 +2226,18 @@ int ar6000_ioctl(struct net_device *dev, struct
> ifreq *rq, int cmd)
>          case AR6000_XIOCTL_HTC_RAW_READ:
>              if (arRawIfEnabled(ar)) {
>                  unsigned int streamID;
> -                get_user(streamID, (unsigned int *)userdata);
> -                get_user(length, (unsigned int *)userdata + 1);
> +             if (get_user(streamID, (unsigned int *)userdata) ||
> +                 get_user(length, (unsigned int *)userdata + 1)) {
> +                 ret = -EFAULT;
> +                 break;
> +             }
>                  buffer = (unsigned char*)rq->ifr_data + sizeof(length);
>                  ret = ar6000_htc_raw_read(ar,
> (HTC_RAW_STREAM_ID)streamID,
>                                            (char*)buffer, length);
> -                put_user(ret, (unsigned int *)rq->ifr_data);
> +             if (put_user(ret, (unsigned int *)rq->ifr_data)) {
> +                 ret = -EFAULT;
> +                 break;
> +             }
>              } else {
>                  ret = A_ERROR;
>              }
> @@ -2210,12 +2246,18 @@ int ar6000_ioctl(struct net_device *dev, struct
> ifreq *rq, int cmd)
>          case AR6000_XIOCTL_HTC_RAW_WRITE:
>              if (arRawIfEnabled(ar)) {
>                  unsigned int streamID;
> -                get_user(streamID, (unsigned int *)userdata);
> -                get_user(length, (unsigned int *)userdata + 1);
> +             if (get_user(streamID, (unsigned int *)userdata) ||
> +                 get_user(length, (unsigned int *)userdata + 1)) {
> +                 ret = -EFAULT;
> +                 break;
> +             }
>                  buffer = (unsigned char*)userdata + sizeof(streamID) +
> sizeof(length);
>                  ret = ar6000_htc_raw_write(ar,
> (HTC_RAW_STREAM_ID)streamID,
>                                             (char*)buffer, length);
> -                put_user(ret, (unsigned int *)rq->ifr_data);
> +             if (put_user(ret, (unsigned int *)rq->ifr_data)) {
> +                 ret = -EFAULT;
> +                 break;
> +             }
>              } else {
>                  ret = A_ERROR;
>              }
> @@ -2223,13 +2265,19 @@ int ar6000_ioctl(struct net_device *dev, struct
> ifreq *rq, int cmd)
>  #endif /* HTC_RAW_INTERFACE */
>
>          case AR6000_XIOCTL_BMI_LZ_STREAM_START:
> -            get_user(address, (unsigned int *)userdata);
> +         if (get_user(address, (unsigned int *)userdata)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>              AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("Start Compressed Stream
> (address: 0x%x)\n", address));
>              ret = BMILZStreamStart(hifDevice, address);
>              break;
>
>          case AR6000_XIOCTL_BMI_LZ_DATA:
> -            get_user(length, (unsigned int *)userdata);
> +         if (get_user(length, (unsigned int *)userdata)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>              AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("Send Compressed Data
> (length: %d)\n", length));
>              if ((buffer = (unsigned char *)A_MALLOC(length)) != NULL) {
>                  A_MEMZERO(buffer, length);
> @@ -2256,8 +2304,11 @@ int ar6000_ioctl(struct net_device *dev, struct
> ifreq *rq, int cmd)
>          {
>              A_UINT32 period;
>              A_UINT32 nbins;
> -            get_user(period, (unsigned int *)userdata);
> -            get_user(nbins, (unsigned int *)userdata + 1);
> +         if (get_user(period, (unsigned int *)userdata) ||
> +             get_user(nbins, (unsigned int *)userdata + 1)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>
>              if (wmi_prof_cfg_cmd(ar->arWmi, period, nbins) != A_OK) {
>                  ret = -EIO;
> @@ -2270,7 +2321,10 @@ int ar6000_ioctl(struct net_device *dev, struct
> ifreq *rq, int cmd)
>          case AR6000_XIOCTL_PROF_ADDR_SET:
>          {
>              A_UINT32 addr;
> -            get_user(addr, (unsigned int *)userdata);
> +         if (get_user(addr, (unsigned int *)userdata)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>
>              if (wmi_prof_addr_set_cmd(ar->arWmi, addr) != A_OK) {
>                  ret = -EIO;
> @@ -2656,30 +2710,29 @@ int ar6000_ioctl(struct net_device *dev, struct
> ifreq *rq, int cmd)
>
>              if (ar->arWmiReady == FALSE) {
>                  ret = -EIO;
> -            } else {
> -                get_user(cmd.ieType, userdata);
> -                if (cmd.ieType >= WMI_MAX_ASSOC_INFO_TYPE) {
> -                    ret = -EIO;
> -                } else {
> -                    get_user(cmd.bufferSize, userdata + 1);
> -                    if (cmd.bufferSize > WMI_MAX_ASSOC_INFO_LEN) {
> -                        ret = -EFAULT;
> -                        break;
> -                    }
> -                    if (copy_from_user(assocInfo, userdata + 2,
> -                                       cmd.bufferSize))
> -                    {
> -                        ret = -EFAULT;
> -                    } else {
> -                        if (wmi_associnfo_cmd(ar->arWmi, cmd.ieType,
> -                                                 cmd.bufferSize,
> -                                                 assocInfo) != A_OK)
> -                        {
> -                            ret = -EIO;
> -                        }
> -                    }
> -                }
> -            }
> +             break;
> +         }
> +
> +         if (get_user(cmd.ieType, userdata))
> +             ret = -EFAULT;
> +             break;
> +         }
> +         if (cmd.ieType >= WMI_MAX_ASSOC_INFO_TYPE) {
> +             ret = -EIO;
> +             break;
> +         }
> +
> +         if (get_user(cmd.bufferSize, userdata + 1) ||
> +             (cmd.bufferSize > WMI_MAX_ASSOC_INFO_LEN) ||
> +             copy_from_user(assocInfo, userdata + 2, cmd.bufferSize)) {
> +             ret = -EFAULT;
> +             break;
> +         }
> +         if (wmi_associnfo_cmd(ar->arWmi, cmd.ieType,
> +                               cmd.bufferSize, assocInfo) != A_OK) {
> +             ret = -EIO;
> +             break;
> +         }
>              break;
>          }
>          case AR6000_IOCTL_WMI_SET_ACCESS_PARAMS:
> @@ -3212,10 +3265,10 @@ int ar6000_ioctl(struct net_device *dev, struct
> ifreq *rq, int cmd)
>          case AR6000_XIOCTRL_WMI_SET_WLAN_STATE:
>          {
>              AR6000_WLAN_STATE state;
> -            get_user(state, (unsigned int *)userdata);
> -            if (ar6000_set_wlan_state(ar, state)!=A_OK) {
> +         if (get_user(state, (unsigned int *)userdata))
> +             ret = -EFAULT;
> +         else if (ar6000_set_wlan_state(ar, state) != A_OK)
>                  ret = -EIO;
> -            }
>              break;
>          }
>          case AR6000_XIOCTL_WMI_GET_ROAM_DATA:
> @@ -3426,19 +3479,28 @@ int ar6000_ioctl(struct net_device *dev, struct
> ifreq *rq, int cmd)
>          case AR6000_XIOCTL_DIAG_READ:
>          {
>              A_UINT32 addr, data;
> -            get_user(addr, (unsigned int *)userdata);
> +         if (get_user(addr, (unsigned int *)userdata)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>              addr = TARG_VTOP(ar->arTargetType, addr);
>              if (ar6000_ReadRegDiag(ar->arHifDevice, &addr, &data) !=
> A_OK) {
>                  ret = -EIO;
>              }
> -            put_user(data, (unsigned int *)userdata + 1);
> +         if (put_user(data, (unsigned int *)userdata + 1)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>              break;
>          }
>          case AR6000_XIOCTL_DIAG_WRITE:
>          {
>              A_UINT32 addr, data;
> -            get_user(addr, (unsigned int *)userdata);
> -            get_user(data, (unsigned int *)userdata + 1);
> +         if (get_user(addr, (unsigned int *)userdata) ||
> +             get_user(data, (unsigned int *)userdata + 1)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>              addr = TARG_VTOP(ar->arTargetType, addr);
>              if (ar6000_WriteRegDiag(ar->arHifDevice, &addr, &data) !=
> A_OK) {
>                  ret = -EIO;
> @@ -3592,12 +3654,18 @@ int ar6000_ioctl(struct net_device *dev, struct
> ifreq *rq, int cmd)
>                  ret = -EIO;
>                  goto ioctl_done;
>              }
> -            get_user(fType, (A_UINT32 *)userdata);
> +         if (get_user(fType, (A_UINT32 *)userdata)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>              appIEcmd.mgmtFrmType = fType;
>              if (appIEcmd.mgmtFrmType >= IEEE80211_APPIE_NUM_OF_FRAME) {
>                  ret = -EIO;
>              } else {
> -                get_user(ieLen, (A_UINT32 *)(userdata + 4));
> +             if (get_user(ieLen, (A_UINT32 *)(userdata + 4))) {
> +                 ret = -EFAULT;
> +                 break;
> +             }
>                  appIEcmd.ieLen = ieLen;
>                  A_PRINTF("WPSIE: Type-%d, Len-%d\n",appIEcmd.mgmtFrmType,
> appIEcmd.ieLen);
>                  if (appIEcmd.ieLen > IEEE80211_APPIE_FRAME_MAX_LEN) {
> @@ -3669,16 +3737,23 @@ int ar6000_ioctl(struct net_device *dev, struct
> ifreq *rq, int cmd)
>              A_UINT32 do_activate;
>              A_UINT32 rompatch_id;
>
> -            get_user(ROM_addr, (A_UINT32 *)userdata);
> -            get_user(RAM_addr, (A_UINT32 *)userdata + 1);
> -            get_user(nbytes, (A_UINT32 *)userdata + 2);
> -            get_user(do_activate, (A_UINT32 *)userdata + 3);
> +         if (get_user(ROM_addr, (A_UINT32 *)userdata) ||
> +             get_user(RAM_addr, (A_UINT32 *)userdata + 1) ||
> +             get_user(nbytes, (A_UINT32 *)userdata + 2) ||
> +             get_user(do_activate, (A_UINT32 *)userdata + 3)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>              AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("Install rompatch from ROM:
> 0x%x to RAM: 0x%x  length: %d\n",
>                               ROM_addr, RAM_addr, nbytes));
>              ret = BMIrompatchInstall(hifDevice, ROM_addr, RAM_addr,
>                                          nbytes, do_activate,
> &rompatch_id);
>              if (ret == A_OK) {
> -                put_user(rompatch_id, (unsigned int *)rq->ifr_data); /*
> return value */
> +             /* return value */
> +             if (put_user(rompatch_id, (unsigned int *)rq->ifr_data)) {
> +                 ret = -EFAULT;
> +                 break;
> +             }
>              }
>              break;
>          }
> @@ -3687,7 +3762,10 @@ int ar6000_ioctl(struct net_device *dev, struct
> ifreq *rq, int cmd)
>          {
>              A_UINT32 rompatch_id;
>
> -            get_user(rompatch_id, (A_UINT32 *)userdata);
> +         if (get_user(rompatch_id, (A_UINT32 *)userdata)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>              AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("UNinstall rompatch_id %d\n",
> rompatch_id));
>              ret = BMIrompatchUninstall(hifDevice, rompatch_id);
>              break;
> @@ -3698,7 +3776,10 @@ int ar6000_ioctl(struct net_device *dev, struct
> ifreq *rq, int cmd)
>          {
>              A_UINT32 rompatch_count;
>
> -            get_user(rompatch_count, (A_UINT32 *)userdata);
> +         if (get_user(rompatch_count, (A_UINT32 *)userdata)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>              AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("Change rompatch activation
> count=%d\n", rompatch_count));
>              length = sizeof(A_UINT32) * rompatch_count;
>              if ((buffer = (unsigned char *)A_MALLOC(length)) != NULL) {
> @@ -4522,7 +4603,10 @@ int ar6000_ioctl(struct net_device *dev, struct
> ifreq *rq, int cmd)
>          case AR6000_XIOCTL_SET_BT_HW_POWER_STATE:
>          {
>              unsigned int state;
> -            get_user(state, (unsigned int *)userdata);
> +         if (get_user(state, (unsigned int *)userdata)) {
> +             ret = -EFAULT;
> +             break;
> +         }
>              if (ar6000_set_bt_hw_state(ar, state)!=A_OK) {
>                  ret = -EIO;
>              }
> --
> 1.7.0.4


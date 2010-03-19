Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0CSXub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 19:50:31 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:52541 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab0CSXu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 19:50:28 -0400
X-SENDER-IP: [83.226.249.136]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkY5AEqqo0tT4vmIPGdsb2JhbACBO4QslWIBAQEBN61zCY1tgmmCEwQ
X-IronPort-AV: E=Sophos;i="4.51,277,1267398000"; 
   d="scan'208";a="53498858"
Message-ID: <4BA40D9E.80507@coyote.org>
Date: Sat, 20 Mar 2010 00:49:50 +0100
From: Lars Lindley <lindley@coyote.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100308 Thunderbird/3.0.3
MIME-Version: 1.0
To: Lars Lindley <lindley@coyote.org>
CC: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mto.c Coding style fixes
References: <1269041205-23129-1-git-send-email-lindley@coyote.org>
In-Reply-To: <1269041205-23129-1-git-send-email-lindley@coyote.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I confirmed that it was only the initializations that changed the .o file.
When I put them back the .o was identical to the one from a clean tree.
It seems like I didn't mess up the ifs anyways.. ;)

/Lars

On 2010-03-20 00:26, Lars Lindley wrote:
> I changed all things reported by checkpatch.pl except some long lines
> and the use of externs in a .c file. I also removed revision comments
> and "commented out" code.
> Please review this closely as the generated .o differs from the
> mainline one but I suspect that is because I removed the explicit
> initialization to 0 in a couple of statics..
> There are also some very deep if-if-else-if-ifs that I might have messed
> up :)
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>
> ---
>  drivers/staging/winbond/mto.c |  299 ++++++++++++++++++-----------------------
>  1 files changed, 129 insertions(+), 170 deletions(-)
> 
> diff --git a/drivers/staging/winbond/mto.c b/drivers/staging/winbond/mto.c
> index 5e7fa1c..9cd2127 100644
> --- a/drivers/staging/winbond/mto.c
> +++ b/drivers/staging/winbond/mto.c
> @@ -1,222 +1,181 @@
> -//============================================================================
> -//  MTO.C -
> -//
> -//  Description:
> -//    MAC Throughput Optimization for W89C33 802.11g WLAN STA.
> -//
> -//    The following MIB attributes or internal variables will be affected
> -//    while the MTO is being executed:
> -//       dot11FragmentationThreshold,
> -//       dot11RTSThreshold,
> -//       transmission rate and PLCP preamble type,
> -//       CCA mode,
> -//       antenna diversity.
> -//
> -//  Revision history:
> -//  --------------------------------------------------------------------------
> -//           20031227  UN20 Pete Chao
> -//                     First draft
> -//  20031229           Turbo                copy from PD43
> -//  20040210           Kevin                revised
> -//  Copyright (c) 2003 Winbond Electronics Corp. All rights reserved.
> -//============================================================================
> -
> -// LA20040210_DTO kevin
> +/*
> + * ============================================================================
> + * MTO.C -
> + *
> + * Description:
> + * MAC Throughput Optimization for W89C33 802.11g WLAN STA.
> + *
> + * The following MIB attributes or internal variables will be affected
> + * while the MTO is being executed:
> + *	dot11FragmentationThreshold,
> + *	dot11RTSThreshold,
> + *	transmission rate and PLCP preamble type,
> + *	CCA mode,
> + *	antenna diversity.
> + *
> + * Copyright (c) 2003 Winbond Electronics Corp. All rights reserved.
> + * ============================================================================
> + */
> +
>  #include "sysdef.h"
>  #include "sme_api.h"
>  #include "wbhal_f.h"
>  
> -// Declare SQ3 to rate and fragmentation threshold table
> -// Declare fragmentation thresholds table
> -#define MTO_MAX_FRAG_TH_LEVELS                  5
> -#define MTO_MAX_DATA_RATE_LEVELS                12
> +/* Declare SQ3 to rate and fragmentation threshold table */
> +/* Declare fragmentation thresholds table */
> +#define MTO_MAX_FRAG_TH_LEVELS		5
> +#define MTO_MAX_DATA_RATE_LEVELS	12
>  
> -u16 MTO_Frag_Th_Tbl[MTO_MAX_FRAG_TH_LEVELS] =
> -{
> -    256, 384, 512, 768, 1536
> +u16 MTO_Frag_Th_Tbl[MTO_MAX_FRAG_TH_LEVELS] = {
> +	256, 384, 512, 768, 1536
>  };
>  
> -// Declare data rate table
> -//The following table will be changed at anytime if the opration rate supported by AP don't
> -//match the table
> +/*
> + * Declare data rate table:
> + * The following table will be changed at anytime if the opration rate
> + * supported by AP don't match the table
> + */
>  static u8 MTO_Data_Rate_Tbl[MTO_MAX_DATA_RATE_LEVELS] = {
> -    2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108
> +	2, 4, 11, 22, 12, 18, 24, 36, 48, 72, 96, 108
>  };
>  
> -static int TotalTxPkt = 0;
> -static int TotalTxPktRetry = 0;
> -static int retryrate_rec[MTO_MAX_DATA_RATE_LEVELS];//this record the retry rate at different data rate
> +static int TotalTxPkt;
> +static int TotalTxPktRetry;
> +/* this record the retry rate at different data rate */
> +static int retryrate_rec[MTO_MAX_DATA_RATE_LEVELS];
>  
> -static int PeriodTotalTxPkt = 0;
> -static int PeriodTotalTxPktRetry = 0;
> +static int PeriodTotalTxPkt;
> +static int PeriodTotalTxPktRetry;
>  
> -static u8 boSparseTxTraffic = false;
> +static u8 boSparseTxTraffic;
>  
>  void MTO_Init(struct wbsoft_priv *adapter);
>  void TxRateReductionCtrl(struct wbsoft_priv *adapter);
> -/** 1.1.31.1000 Turbo modify */
>  void MTO_SetTxCount(struct wbsoft_priv *adapter, u8 t0, u8 index);
>  void MTO_TxFailed(struct wbsoft_priv *adapter);
>  void hal_get_dto_para(struct wbsoft_priv *adapter, char *buffer);
>  
> -//===========================================================================
> -//  MTO_Init --
> -//
> -//  Description:
> -//    Initialize MTO parameters.
> -//
> -//    This function should be invoked during system initialization.
> -//
> -//  Arguments:
> -//    adapter      - The pointer to the Miniport adapter Context
> -//
> -//  Return Value:
> -//    None
> -//============================================================================
> +/*
> + * ===========================================================================
> + * MTO_Init --
> + *
> + *  Description:
> + *    Initialize MTO parameters.
> + *
> + *    This function should be invoked during system initialization.
> + *
> + *  Arguments:
> + *    adapter      - The pointer to the Miniport adapter Context
> + * ===========================================================================
> + */
>  void MTO_Init(struct wbsoft_priv *adapter)
>  {
> -    int i;
> -
> -    //[WKCHEN]MTO_CCA_MODE_SETUP()= (u8) hal_get_cca_mode(MTO_HAL());
> -    //[WKCHEN]MTO_CCA_MODE()      = MTO_CCA_MODE_SETUP();
> -
> -    //MTO_PREAMBLE_TYPE() = MTO_PREAMBLE_LONG;
> -    MTO_PREAMBLE_TYPE() = MTO_PREAMBLE_SHORT;   // for test
> -
> -    MTO_CNT_ANT(0)      = 0;
> -    MTO_CNT_ANT(1)      = 0;
> -    MTO_SQ_ANT(0)       = 0;
> -    MTO_SQ_ANT(1)       = 0;
> -
> -    MTO_AGING_TIMEOUT() = 0;
> -
> -    // The following parameters should be initialized to the values set by user
> -    //
> -    //MTO_RATE_LEVEL()            = 10;
> -    MTO_RATE_LEVEL()            = 0;
> -    MTO_FRAG_TH_LEVEL()         = 4;
> -    /** 1.1.23.1000 Turbo modify from -1 to +1
> -	MTO_RTS_THRESHOLD()         = MTO_FRAG_TH() - 1;
> -    MTO_RTS_THRESHOLD_SETUP()   = MTO_FRAG_TH() - 1;
> -	*/
> -	MTO_RTS_THRESHOLD()         = MTO_FRAG_TH() + 1;
> -    MTO_RTS_THRESHOLD_SETUP()   = MTO_FRAG_TH() + 1;
> -    // 1.1.23.1000 Turbo add for mto change preamble from 0 to 1
> -	MTO_RATE_CHANGE_ENABLE()    = 1;
> -    MTO_FRAG_CHANGE_ENABLE()    = 0;          // 1.1.29.1000 Turbo add don't support frag
> -	//The default valud of ANTDIV_DEFAULT_ON will be decided by EEPROM
> -	//#ifdef ANTDIV_DEFAULT_ON
> -	//#else
> -	//#endif
> -    MTO_POWER_CHANGE_ENABLE()   = 1;
> -	MTO_PREAMBLE_CHANGE_ENABLE()= 1;
> -    MTO_RTS_CHANGE_ENABLE()     = 0;          // 1.1.29.1000 Turbo add don't support frag
> -    // 20040512 Turbo add
> -	//old_antenna[0] = 1;
> -	//old_antenna[1] = 0;
> -	//old_antenna[2] = 1;
> -	//old_antenna[3] = 0;
> -	for (i=0;i<MTO_MAX_DATA_RATE_LEVELS;i++)
> -		retryrate_rec[i]=5;
> +	int i;
> +
> +	MTO_PREAMBLE_TYPE() = MTO_PREAMBLE_SHORT;   /* for test */
> +
> +	MTO_CNT_ANT(0)			= 0;
> +	MTO_CNT_ANT(1)			= 0;
> +	MTO_SQ_ANT(0)			= 0;
> +	MTO_SQ_ANT(1)			= 0;
> +
> +	MTO_AGING_TIMEOUT()		= 0;
> +
> +	/* The following parameters should be initialized to the values set by user */
> +	MTO_RATE_LEVEL()		= 0;
> +	MTO_FRAG_TH_LEVEL()		= 4;
> +	MTO_RTS_THRESHOLD()		= MTO_FRAG_TH() + 1;
> +	MTO_RTS_THRESHOLD_SETUP()	= MTO_FRAG_TH() + 1;
> +	MTO_RATE_CHANGE_ENABLE()	= 1;
> +	MTO_FRAG_CHANGE_ENABLE()	= 0;
> +	MTO_POWER_CHANGE_ENABLE()	= 1;
> +	MTO_PREAMBLE_CHANGE_ENABLE()	= 1;
> +	MTO_RTS_CHANGE_ENABLE()		= 0;
> +
> +	for (i = 0; i < MTO_MAX_DATA_RATE_LEVELS; i++)
> +		retryrate_rec[i] = 5;
>  
>  	MTO_TXFLOWCOUNT() = 0;
> -	//--------- DTO threshold parameters -------------
> -	//MTOPARA_PERIODIC_CHECK_CYCLE() = 50;
> -	MTOPARA_PERIODIC_CHECK_CYCLE() = 10;
> -	MTOPARA_RSSI_TH_FOR_ANTDIV() = 10;
> -	MTOPARA_TXCOUNT_TH_FOR_CALC_RATE() = 50;
> -	MTOPARA_TXRATE_INC_TH()	= 10;
> -	MTOPARA_TXRATE_DEC_TH() = 30;
> -	MTOPARA_TXRATE_EQ_TH() = 40;
> -	MTOPARA_TXRATE_BACKOFF() = 12;
> -	MTOPARA_TXRETRYRATE_REDUCE() = 6;
> -	if ( MTO_TXPOWER_FROM_EEPROM == 0xff)
> -	{
> -		switch( MTO_HAL()->phy_type)
> -		{
> -			case RF_AIROHA_2230:
> -			case RF_AIROHA_2230S: // 20060420 Add this
> -				MTOPARA_TXPOWER_INDEX() = 46; // MAX-8 // @@ Only for AL 2230
> -				break;
> -			case RF_AIROHA_7230:
> -				MTOPARA_TXPOWER_INDEX() = 49;
> -				break;
> -			case RF_WB_242:
> -				MTOPARA_TXPOWER_INDEX() = 10;
> -				break;
> -			case RF_WB_242_1:
> -				MTOPARA_TXPOWER_INDEX() = 24; // ->10 20060316.1 modify
> -				break;
> +	/* --------- DTO threshold parameters ------------- */
> +	MTOPARA_PERIODIC_CHECK_CYCLE()		= 10;
> +	MTOPARA_RSSI_TH_FOR_ANTDIV()		= 10;
> +	MTOPARA_TXCOUNT_TH_FOR_CALC_RATE()	= 50;
> +	MTOPARA_TXRATE_INC_TH()			= 10;
> +	MTOPARA_TXRATE_DEC_TH()			= 30;
> +	MTOPARA_TXRATE_EQ_TH()			= 40;
> +	MTOPARA_TXRATE_BACKOFF()		= 12;
> +	MTOPARA_TXRETRYRATE_REDUCE()		= 6;
> +	if (MTO_TXPOWER_FROM_EEPROM == 0xff) {
> +		switch (MTO_HAL()->phy_type) {
> +		case RF_AIROHA_2230:
> +		case RF_AIROHA_2230S:
> +			MTOPARA_TXPOWER_INDEX() = 46; /* MAX-8 @@ Only for AL 2230 */
> +			break;
> +		case RF_AIROHA_7230:
> +			MTOPARA_TXPOWER_INDEX() = 49;
> +			break;
> +		case RF_WB_242:
> +			MTOPARA_TXPOWER_INDEX() = 10;
> +			break;
> +		case RF_WB_242_1:
> +			MTOPARA_TXPOWER_INDEX() = 24;
> +			break;
>  		}
> -	}
> -	else	//follow the setting from EEPROM
> +	} else { /* follow the setting from EEPROM */
>  		MTOPARA_TXPOWER_INDEX() = MTO_TXPOWER_FROM_EEPROM;
> -	RFSynthesizer_SetPowerIndex(MTO_HAL(), (u8)MTOPARA_TXPOWER_INDEX());
> -	//------------------------------------------------
> +	}
> +	RFSynthesizer_SetPowerIndex(MTO_HAL(), (u8) MTOPARA_TXPOWER_INDEX());
> +	/* ------------------------------------------------ */
>  
> -	// For RSSI turning 20060808.4 Cancel load from EEPROM
> +	/* For RSSI turning -- Cancel load from EEPROM */
>  	MTO_DATA().RSSI_high = -41;
>  	MTO_DATA().RSSI_low = -60;
>  }
>  
> -//===========================================================================
> -//  Description:
> -//      If we enable DTO, we will ignore the tx count with different tx rate from
> -//      DTO rate. This is because when we adjust DTO tx rate, there could be some
> -//      packets in the tx queue with previous tx rate
> +/* ===========================================================================
> + * Description:
> + *	If we enable DTO, we will ignore the tx count with different tx rate
> + *	from DTO rate. This is because when we adjust DTO tx rate, there could
> + *	be some packets in the tx queue with previous tx rate
> + */
> +
>  void MTO_SetTxCount(struct wbsoft_priv *adapter, u8 tx_rate, u8 index)
>  {
>  	MTO_TXFLOWCOUNT()++;
> -	if ((MTO_ENABLE==1) && (MTO_RATE_CHANGE_ENABLE()==1))
> -	{
> -		if(tx_rate == MTO_DATA_RATE())
> -		{
> -			if (index == 0)
> -			{
> +	if ((MTO_ENABLE == 1) && (MTO_RATE_CHANGE_ENABLE() == 1)) {
> +		if (tx_rate == MTO_DATA_RATE()) {
> +			if (index == 0) {
>  				if (boSparseTxTraffic)
>  					MTO_HAL()->dto_tx_frag_count += MTOPARA_PERIODIC_CHECK_CYCLE();
>  				else
>  					MTO_HAL()->dto_tx_frag_count += 1;
> -			}
> -			else
> -			{
> -				if (index<8)
> -				{
> +			} else {
> +				if (index < 8) {
>  					MTO_HAL()->dto_tx_retry_count += index;
> -					MTO_HAL()->dto_tx_frag_count += (index+1);
> -				}
> -				else
> -				{
> +					MTO_HAL()->dto_tx_frag_count += (index + 1);
> +				} else {
>  					MTO_HAL()->dto_tx_retry_count += 7;
>  					MTO_HAL()->dto_tx_frag_count += 7;
>  				}
>  			}
> -		}
> -		else if(MTO_DATA_RATE()>48 && tx_rate ==48)
> -		{//ALFRED
> -			if (index<3) //for reduciing data rate scheme ,
> -				         //do not calcu different data rate
> -						 //3 is the reducing data rate at retry
> -			{
> +		} else if (MTO_DATA_RATE() > 48 && tx_rate == 48) {
> +			/* for reducing data rate scheme, do not calculate different data rate. 3 is the reducing data rate at retry. */
> +			if (index < 3) {
>  				MTO_HAL()->dto_tx_retry_count += index;
> -				MTO_HAL()->dto_tx_frag_count += (index+1);
> -			}
> -			else
> -			{
> +				MTO_HAL()->dto_tx_frag_count += (index + 1);
> +			} else {
>  				MTO_HAL()->dto_tx_retry_count += 3;
>  				MTO_HAL()->dto_tx_frag_count += 3;
>  			}
>  
>  		}
> -	}
> -	else
> -	{
> +	} else {
>  		MTO_HAL()->dto_tx_retry_count += index;
> -		MTO_HAL()->dto_tx_frag_count += (index+1);
> +		MTO_HAL()->dto_tx_frag_count += (index + 1);
>  	}
> -	TotalTxPkt ++;
> -	TotalTxPktRetry += (index+1);
> +	TotalTxPkt++;
> +	TotalTxPktRetry += (index + 1);
>  
> -	PeriodTotalTxPkt ++;
> -	PeriodTotalTxPktRetry += (index+1);
> +	PeriodTotalTxPkt++;
> +	PeriodTotalTxPktRetry += (index + 1);
>  }

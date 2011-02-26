Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab1BZKky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 05:40:54 -0500
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:52012 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1BZKkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 05:40:51 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D68D8CB.1050108@cam.ac.uk>
Date: Sat, 26 Feb 2011 10:41:15 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg Schnorr <gschnorr@cisco.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/5] hwmon: PMBus device driver
References: <1297969217-9564-1-git-send-email-guenter.roeck@ericsson.com> <1297969217-9564-2-git-send-email-guenter.roeck@ericsson.com> <4D680FAE.80600@cam.ac.uk> <20110226024552.GA14032@ericsson.com>
In-Reply-To: <20110226024552.GA14032@ericsson.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/11 02:45, Guenter Roeck wrote:
> On Fri, Feb 25, 2011 at 03:23:10PM -0500, Jonathan Cameron wrote:
>> On 02/17/11 19:00, Guenter Roeck wrote:
>>> This driver adds support for hardware monitoring features of various PMBus
>>> devices.
>>
>> Hi Guenter, I'm afraid this isn't the most thorough review ever, but there
>> are a few questions I'd like answered inline. These devices are pretty ugly.
>>
> Hi Jonathan,
> 
> given the complexity of the driver I am very happy you found the time!
> 
>> I'm also a little unhappy with how often you clear faults without it being
>> obvious why.  Please have another look at this and add clarifying comments...
>>
> Mostly that was to make me feel safer. I removed some; hope it is better now.
> 
>> I've suggested use of some macros inline. Not sure whether it's actualy a good
>> idea though. What do you think?
>>
> I actually had more function macros in the code, but I am getting a bit away 
> from it after I noticed that it often just obfuscates the code. Only reason
> for not removing the remaining the function macros is that I didn't find
> a clean way to replace them with actual code or functions.
Fair enough. They would have been really ugly macros.  Just feels like there ought
to be a cleaner way of handling those big chunks of very predicable code!  Maybe
some sort of array of structs with all the relevant info in them?
> 
>> Other than request for a few more comments to explain bits that weren't immediately
>> obvious, the only bit I'd really question is the necessity of the list of pmbus
>> devices.  I might have missed something there though...
>>
> That is pretty much just to be able to clean up an entry. More see below.
> 
>> Thanks,
>>
>> Jonathan
>>
>>>
>>> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
>>> ---
>>>  drivers/hwmon/Kconfig      |   25 +
>>>  drivers/hwmon/Makefile     |    4 +
>>>  drivers/hwmon/pmbus.c      |  234 +++++++
>>>  drivers/hwmon/pmbus.h      |  307 +++++++++
>>>  drivers/hwmon/pmbus_core.c | 1611 ++++++++++++++++++++++++++++++++++++++++++++
>>>  include/linux/i2c/pmbus.h  |   45 ++
>>>  6 files changed, 2226 insertions(+), 0 deletions(-)
>>>  create mode 100644 drivers/hwmon/pmbus.c
>>>  create mode 100644 drivers/hwmon/pmbus.h
>>>  create mode 100644 drivers/hwmon/pmbus_core.c
>>>  create mode 100644 include/linux/i2c/pmbus.h
>>>
>>> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
>>> index 773e484..9f20e56 100644
>>> --- a/drivers/hwmon/Kconfig
>>> +++ b/drivers/hwmon/Kconfig
>>> @@ -734,6 +734,31 @@ config SENSORS_PCF8591
>>>         These devices are hard to detect and rarely found on mainstream
>>>         hardware.  If unsure, say N.
>>>
>>> +config PMBUS
>>> +     tristate "PMBus support"
> 
> Side note: that should really be a boolean. Will be fixed in next version.
> 
Why?  Can't the pmbus core stuff be a module?
>>> +     depends on I2C && EXPERIMENTAL
>>> +     default n
>>> +     help
>>> +       Say yes here if you want to enable PMBus support.
>>> +
>>> +       This driver can also be built as a module. If so, the module will
>>> +       be called pmbus_core.
>>> +
...
>>> +}
>>> +
>>> +static int pmbus_probe(struct i2c_client *client,
>>> +                    const struct i2c_device_id *id)
>>> +{
>>> +     struct pmbus_entry *pe;
>>> +     int ret;
>>> +
>>> +     pe = kzalloc(sizeof(struct pmbus_entry), GFP_KERNEL);
>>> +     if (!pe)
>>> +             return -ENOMEM;
>>> +
>>> +     pe->client = client;
>>> +     mutex_lock(&pmbus_list_mutex);
>>> +     list_add_tail(&pe->list, &pmbus_list);
>>> +     mutex_unlock(&pmbus_list_mutex);
>> I'm a little unclear why the list is needed.  Looks like it is used
>> for cleanup purposes. i2c_set_clientdata gets called with a struct pmbus_data *data
> 
> Correct.
> 
>> in pmbus_do_probe.  That structure has a pointer to struct pmbus_driver_info info
>> currently effectively stored in this list.  Hence, if we don't have the list
>> I think we can create a pmbus_driver_info struct directly here and get to it via
>> ((struct pmbus_data *)(i2c_get_clientdata(client))->info to free the structure
>> on remove.
>>
> You are right, though that would require context information which is currently 
> not exported from pmbus_core.c. Specifically, pmbus.c would need to know about
> struct pmbus_data which is private to pmbus_core.c. I would prefer to keep it that way.
> 
> Maybe I could add an API call into pmbus_core.c to retrieve a pointer to pmbus_driver_info.
> Do you think that would make sense ? I am a bit at odds with myself if the list or an
> API function (or something else ?) would be better.
> 
Are I'd missed the issue with the struct definition being private.

API call is probably the cleanest option.  The list just seems to be be adding complexity
for no actual gain.

>>> +bool pmbus_check_word_register(struct i2c_client *client, int page, int reg)
>>> +{
>>> +     int rv, status;
>>> +     struct pmbus_data *data = i2c_get_clientdata(client);
>>> +
>>> +     pmbus_write_byte(client, page, PMBUS_CLEAR_FAULTS);
>> If there have been faults, do we not want to have handled them?
>> That is, should there be any circumstance under which we would want
>> to clear one here?x
> 
> That is one place where it is really needed. Status codes are sticky, so if 
> "PB_CML_FAULT_INVALID_COMMAND" was set for whatever reason, it would be reported
> below even if the following access is ok.
They wouldn't you ideally pick that up and report it when it first occurs rather
than clearing it here?  i.e. Clear whenever it occurs not at the top of a later
function that wants to check the same error code...
> 
>>> +     rv = pmbus_read_word_data(client, page, reg);
>>
>> I think this is idenical to the check code in the previous function.
>> Worth pulling out to a utility function used by both?
> 
> Yes, excellent idea.
> 
>>> +     if (rv >= 0 && !(data->flags & PMBUS_SKIP_STATUS_CHECK)) {
>>> +             status = pmbus_read_byte_data(client, page, PMBUS_STATUS_BYTE);
>>> +             if (status < 0 || (status & PB_STATUS_CML)) {
>>> +                     int status2 = pmbus_read_byte_data(client, page,
>>> +                                                        PMBUS_STATUS_CML);
>>> +                     if (status2 < 0
>>> +                         || (status2 & PB_CML_FAULT_INVALID_COMMAND)) {
>>> +                             dev_dbg(&client->dev,
>>> +                                     "page %d reg 0x%x status 0x%x-0x%x\n",
>>> +                                     page, reg, status, status2);
>>> +                             rv = -EINVAL;
>>> +                     }
>>> +             }
>>> +     }
>>> +     pmbus_write_byte(client, page, PMBUS_CLEAR_FAULTS);
> 
> This one isn't strictly needed, though, so I removed it.
> 
Good

....
>>> +
>>> +/*
>>> + * Return boolean calculated from converted data.
>>> + * <index> defines a status register index and mask, and optionally
>>> + * two sensor indexes.
>>> + * The upper half-word references the two sensors,
>>> + * the lower half word references status register and mask.
>>> + * The function returns true if (status[reg] & mask) is true and,
>>> + * if specified, if v1 >= v2.
>>> + * To determine if an object exceeds upper limits, specify <v, limit>.
>>> + * To determine if an object exceeds lower limits, specify <limit, v>.
>>> + */
>>> +static int pmbus_get_boolean(struct pmbus_data *data, int index, int *val)
>>> +{
>>> +     u8 s1 = (index >> 24) & 0xff;
>>> +     u8 s2 = (index >> 16) & 0xff;
>>> +     u8 reg = (index >> 8) & 0xff;
>>> +     u8 mask = index & 0xff;
>>> +     int status;
>>> +     u8 regval;
>>> +
>>> +     status = data->status[reg];
>>> +     if (status < 0)
>>> +             return status;
>>> +
>>> +     regval = status & mask;
>>
>> This test could do with a simple explanatory comment (which is another
>> way of saying I'm not quite clear why this makes sense!)
> 
> You mean the following test ? If both s1 and s2 are 0, the function 
> returns the result of (status & mask). This is for all booleans 
> which are created with pmbus_add_boolean_reg().
> 
> Otherwise, the result is determined by comparison as described above.
> 
> I'll add additional comments to describe this in more detail.
Cool. My issue was I couldn't tell what s1 and s2 actually are.
> 
>>> +     if (!s1 && !s2)
>>> +             *val = !!regval;
>>> +     else {
>>> +             int v1, v2;
>>> +             struct pmbus_sensor *sensor1, *sensor2;
>>> +
>>> +             sensor1 = &data->sensors[s1];
>>> +             if (sensor1->data < 0)
>>> +                     return sensor1->data;
>>> +             sensor2 = &data->sensors[s2];
>>> +             if (sensor2->data < 0)
>>> +                     return sensor2->data;
>>> +
>>> +             v1 = pmbus_reg2data(data, sensor1);
>>> +             v2 = pmbus_reg2data(data, sensor2);
>>> +             *val = !!(regval && v1 >= v2);
>>> +     }
>>> +     return 0;
>>> +}
>>> +
>>> +static ssize_t pmbus_show_boolean(struct device *dev,
>>> +                               struct device_attribute *da, char *buf)
>>> +{
>>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
>>> +     struct pmbus_data *data = pmbus_update_device(dev);
>>> +     int val;
>>> +     int err;
>>> +
>>> +     err = pmbus_get_boolean(data, attr->index, &val);
>>> +     if (err)
>>> +             return err;
>>> +     return snprintf(buf, PAGE_SIZE, "%d\n", val);
>>> +}
>>> +
>>> +static ssize_t pmbus_show_sensor(struct device *dev,
>>> +                              struct device_attribute *da, char *buf)
>>> +{
>>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
>>> +     struct pmbus_data *data = pmbus_update_device(dev);
>>> +     struct pmbus_sensor *sensor;
>>> +
>>> +     sensor = &data->sensors[attr->index];
>>> +     if (sensor->data < 0)
>>> +             return sensor->data;
>>> +
>>> +     return snprintf(buf, PAGE_SIZE, "%d\n", pmbus_reg2data(data, sensor));
>>> +}
>>> +
>>> +static ssize_t pmbus_set_sensor(struct device *dev,
>>> +                             struct device_attribute *devattr,
>>> +                             const char *buf, size_t count)
>>> +{
>>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>>> +     struct i2c_client *client = to_i2c_client(dev);
>>> +     struct pmbus_data *data = i2c_get_clientdata(client);
>>> +     struct pmbus_sensor *sensor = &data->sensors[attr->index];
>>> +     ssize_t rv = count;
>>> +     long val = 0;
>>> +     int ret;
>>> +     u16 regval;
>>> +
>>> +     if (strict_strtol(buf, 10, &val) < 0)
>>> +             return -EINVAL;
>>> +
>>> +     mutex_lock(&data->update_lock);
>>> +     regval = pmbus_data2reg(data, sensor->class, val);
>>> +     ret = pmbus_write_word_data(client, sensor->page, sensor->reg, regval);
>>> +     if (ret < 0)
>>> +             rv = ret;
>>> +     else
>>> +             data->sensors[attr->index].data = regval;
>>> +     mutex_unlock(&data->update_lock);
>>> +     return rv;
>>> +}
>>> +
>>> +static ssize_t pmbus_show_label(struct device *dev,
>>> +                             struct device_attribute *da, char *buf)
>>> +{
>>> +     struct i2c_client *client = to_i2c_client(dev);
>>> +     struct pmbus_data *data = i2c_get_clientdata(client);
>>> +     struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
>>> +
>>> +     return snprintf(buf, PAGE_SIZE, "%s\n",
>>> +                     data->labels[attr->index].label);
>>> +}
>>> +
>>> +#define PMBUS_ADD_ATTR(data, _name, _idx, _mode, _type, _show, _set) \
>>> +do {                                                                 \
>>> +     struct sensor_device_attribute *a                               \
>>> +         = &data->_type##s[data->num_##_type##s].attribute;          \
>>> +     BUG_ON(data->num_attributes >= data->max_attributes);           \
>>> +     a->dev_attr.attr.name = _name;                                  \
>>> +     a->dev_attr.attr.mode = _mode;                                  \
>>> +     a->dev_attr.show = _show;                                       \
>>> +     a->dev_attr.store = _set;                                       \
>>> +     a->index = _idx;                                                \
>>> +     data->attributes[data->num_attributes] = &a->dev_attr.attr;     \
>>> +     data->num_attributes++;                                         \
>>> +} while (0)
>>> +
>>> +#define PMBUS_ADD_GET_ATTR(data, _name, _type, _idx)                 \
>>> +     PMBUS_ADD_ATTR(data, _name, _idx, S_IRUGO, _type,               \
>>> +                    pmbus_show_##_type,  NULL)
>>> +
>>> +#define PMBUS_ADD_SET_ATTR(data, _name, _type, _idx)                 \
>>> +     PMBUS_ADD_ATTR(data, _name, _idx, S_IWUSR | S_IRUGO, _type,     \
>>> +                    pmbus_show_##_type, pmbus_set_##_type)
>>> +
>>> +static void pmbus_add_boolean(struct pmbus_data *data,
>>> +                           const char *name, const char *type, int seq,
>> Is val the best name for the next variable?  It isn't obvious to me what
>> value this is... Gets pushed into an index by the PMBUS_ADD_GET_ATTR macro...
>> Perhaps keep the idx naming?
> 
> Not sure myself. val is composed of up to four individual parameters.
> I'll name it idx.
> 
>>> +                           int val)
>>> +{
>>> +     struct pmbus_boolean *boolean;
>>> +
>>> +     BUG_ON(data->num_booleans >= data->max_booleans);
>>> +
>>> +     boolean = &data->booleans[data->num_booleans];
>>> +
>>> +     snprintf(boolean->name, sizeof(boolean->name), "%s%d_%s",
>>> +              name, seq, type);
>>> +     PMBUS_ADD_GET_ATTR(data, boolean->name, boolean, val);
>>> +     data->num_booleans++;
>>> +}
>>> +
>>> +static void pmbus_add_boolean_reg(struct pmbus_data *data,
>>> +                               const char *name, const char *type,
>>> +                               int seq, int reg, int bit)
>>> +{
>>> +     pmbus_add_boolean(data, name, type, seq, (reg << 8) | bit);
>>> +}
>>> +
>>> +static void pmbus_add_boolean_cmp(struct pmbus_data *data,
>>> +                               const char *name, const char *type,
>>> +                               int seq, int i1, int i2, int reg, int mask)
>>> +{
>>> +     pmbus_add_boolean(data, name, type, seq,
>>> +                       (i1 << 24) | (i2 << 16) | (reg << 8) | mask);
>>> +}
>>> +
>>> +static void pmbus_add_sensor(struct pmbus_data *data,
>>> +                          const char *name, const char *type, int seq,
>>> +                          int page, int reg, enum pmbus_sensor_classes class,
>>> +                          bool update)
>>> +{
>>> +     struct pmbus_sensor *sensor;
>>> +
>>> +     BUG_ON(data->num_sensors >= data->max_sensors);
>>> +
>>> +     sensor = &data->sensors[data->num_sensors];
>>> +     snprintf(sensor->name, sizeof(sensor->name), "%s%d_%s",
>>> +              name, seq, type);
>>> +     sensor->page = page;
>>> +     sensor->reg = reg;
>>> +     sensor->class = class;
>>> +     sensor->update = update;
>>> +     if (update)
>>> +             PMBUS_ADD_GET_ATTR(data, sensor->name, sensor,
>>> +                                data->num_sensors);
>>> +     else
>>> +             PMBUS_ADD_SET_ATTR(data, sensor->name, sensor,
>>> +                                data->num_sensors);
>>> +     data->num_sensors++;
>>> +}
>>> +
>>> +static void pmbus_add_label(struct pmbus_data *data,
>>> +                         const char *name, int seq,
>>> +                         const char *lstring, int index)
>>> +{
>>> +     struct pmbus_label *label;
>>> +
>>> +     BUG_ON(data->num_labels >= data->max_labels);
>>> +
>>> +     label = &data->labels[data->num_labels];
>>> +     snprintf(label->name, sizeof(label->name), "%s%d_label", name, seq);
>>> +     if (!index)
>>> +             strncpy(label->label, lstring, sizeof(label->label) - 1);
>>> +     else
>>> +             snprintf(label->label, sizeof(label->label), "%s%d", lstring,
>>> +                      index);
>>> +
>>> +     PMBUS_ADD_GET_ATTR(data, label->name, label, data->num_labels);
>>> +     data->num_labels++;
>>> +}
>>> +
>> const?
> 
> yes
> 
>>> +static int pmbus_temp_registers[] = {
>>> +     PMBUS_READ_TEMPERATURE_1,
>>> +     PMBUS_READ_TEMPERATURE_2,
>>> +     PMBUS_READ_TEMPERATURE_3
>>> +};
>>> +
>>> +static int pmbus_fan_registers[] = {
>>> +     PMBUS_READ_FAN_SPEED_1,
>>> +     PMBUS_READ_FAN_SPEED_2,
>>> +     PMBUS_READ_FAN_SPEED_3,
>>> +     PMBUS_READ_FAN_SPEED_4
>>> +};
>>> +
>>> +static int pmbus_fan_config_registers[] = {
>>> +     PMBUS_FAN_CONFIG_12,
>>> +     PMBUS_FAN_CONFIG_12,
>>> +     PMBUS_FAN_CONFIG_34,
>>> +     PMBUS_FAN_CONFIG_34
>>> +};
>>> +
>>> +static int pmbus_fan_status_registers[] = {
>>> +     PMBUS_STATUS_FAN_12,
>>> +     PMBUS_STATUS_FAN_12,
>>> +     PMBUS_STATUS_FAN_34,
>>> +     PMBUS_STATUS_FAN_34
>>> +};
>>> +
>>> +/*
>>> + * Determine maximum number of sensors, booleans, and labels.
>>> + * To keep things simple, only make a rough high estimate.
>>> + */
>>> +static void pmbus_find_max_attr(struct i2c_client *client,
>>> +                             struct pmbus_data *data)
>>> +{
>>> +     const struct pmbus_driver_info *info = data->info;
>>> +     int page, max_sensors, max_booleans, max_labels;
>>> +
>>> +     max_sensors = PMBUS_MAX_INPUT_SENSORS;
>>> +     max_booleans = PMBUS_MAX_INPUT_BOOLEANS;
>>> +     max_labels = PMBUS_MAX_INPUT_LABELS;
>>> +
>>> +     for (page = 0; page < info->pages; page++) {
>>> +             if (info->func[page] & PMBUS_HAVE_VOUT) {
>>> +                     max_sensors += PMBUS_VOUT_SENSORS_PER_PAGE;
>>> +                     max_booleans += PMBUS_VOUT_BOOLEANS_PER_PAGE;
>>> +                     max_labels++;
>>> +             }
>>> +             if (info->func[page] & PMBUS_HAVE_IOUT) {
>>> +                     max_sensors += PMBUS_IOUT_SENSORS_PER_PAGE;
>>> +                     max_booleans += PMBUS_IOUT_BOOLEANS_PER_PAGE;
>>> +                     max_labels++;
>>> +             }
>>> +             if (info->func[page] & PMBUS_HAVE_POUT) {
>>> +                     max_sensors += PMBUS_POUT_SENSORS_PER_PAGE;
>>> +                     max_booleans += PMBUS_POUT_BOOLEANS_PER_PAGE;
>>> +                     max_labels++;
>>> +             }
>>> +             if (info->func[page] & PMBUS_HAVE_FAN12) {
>>> +                     if (page == 0) {
>>> +                             max_sensors +=
>>> +                                 ARRAY_SIZE(pmbus_fan_registers) *
>>> +                                 PMBUS_MAX_SENSORS_PER_FAN;
>>> +                             max_booleans +=
>>> +                                 ARRAY_SIZE(pmbus_fan_registers) *
>>> +                                 PMBUS_MAX_BOOLEANS_PER_FAN;
>>> +                     } else {
>>> +                             max_sensors += PMBUS_MAX_SENSORS_PER_FAN;
>>> +                             max_booleans += PMBUS_MAX_BOOLEANS_PER_FAN;
>>> +                     }
>>> +             }
>>> +             if (info->func[page] & PMBUS_HAVE_TEMP) {
>>> +                     if (page == 0) {
>>> +                             max_sensors +=
>>> +                                 ARRAY_SIZE(pmbus_temp_registers) *
>>> +                                 PMBUS_MAX_SENSORS_PER_TEMP;
>>> +                             max_booleans +=
>>> +                                 ARRAY_SIZE(pmbus_temp_registers) *
>>> +                                 PMBUS_MAX_BOOLEANS_PER_TEMP;
>>> +                     } else {
>>> +                             max_sensors += PMBUS_MAX_SENSORS_PER_TEMP;
>>> +                             max_booleans += PMBUS_MAX_BOOLEANS_PER_TEMP;
>>> +                     }
>>> +             }
>>> +     }
>>> +     data->max_sensors = max_sensors;
>>> +     data->max_booleans = max_booleans;
>>> +     data->max_labels = max_labels;
>>> +     data->max_attributes = max_sensors + max_booleans + max_labels;
>>> +}
>>> +
>>> +/*
>>> + * Search for attributes. Allocate sensors, booleans, and labels as needed.
>>> + */
>>> +static void pmbus_find_attributes(struct i2c_client *client,
>>> +                               struct pmbus_data *data)
>>> +{
>>> +     const struct pmbus_driver_info *info = data->info;
>>> +     int page, i0, i1, in_index;
>>> +
>>> +     /*
>>> +      * Input voltage sensors
>>> +      */
>>> +     in_index = 1;
>>> +     if (info->func[0] & PMBUS_HAVE_VIN) {
>>> +             bool have_alarm = false;
>>> +
>>> +             i0 = data->num_sensors;
>>> +             pmbus_add_label(data, "in", in_index, "vin", 0);
>>> +             pmbus_add_sensor(data, "in", "input", in_index,
>>> +                              0, PMBUS_READ_VIN, PSC_VOLTAGE_IN, true);
>>
>> This next lot do rather look like they could be done using an inline function
>> or a macro...
>>
>> Something like...
>> #define bob(LIM, NAME, POST, WHAT, TYPE)
>> if (pmbus_check_word_register(client, 0, LIM)) {
>>    i1 = data->num_sensors;
>>    pmbus_add_sensor(data, NAME, POST, in_index, 0, LIM, WHAT, false);
>>    if (info->func[0] & PMBUS_HAV_STATUS_INPUT) {
>>    pmbus_add_boolean_reg(data, NAME, POST##_alarm, in_index, PBU_STATUS_INPUT_BASE,
>>    TYPE);
>>    have_alarm = true;
>> }
>> }
>>
>> bob(PMBUS_VIN_UV_WARN_LIMIT, "in", "min", PSC_VOLTAGE_IN, PB_VOLTAGE_UV_WARNING);
>> bob(PMBUS_VIN_UV_FAULT_LIMIT, "in", "lcrit", PSC_VOLTAGE_IN, PB_VOLTAGE_UV_FAULT);
>> bob(PMBUS_VIN_OV_WARN_LIMIT, "in", "max", PSC_VOLTAGE_IN, PB_VOLTAGE_OV_WARNING);
>> etc.
>>
>> basically I'm observing a lot of shared code in these...  Still maybe this
>> just acts to hide what is going on.
> 
> I think I would prefer to keep it as-is. I am not really a friend of function macros
> anymore.
> 
> It would be different if I can extract some of the code into functions, but right now 
> I don't see how I could do that.
> 
Agreed. When I started looking at that I thought it would be easy to do as a function,
but the code is way to invasive and you would need a lot of parameters to make that work...

Fine as is then...
